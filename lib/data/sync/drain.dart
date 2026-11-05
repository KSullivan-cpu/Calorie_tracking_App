import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured, db;
import 'reconciliation.dart';
import 'sync_health.dart';

/// Outbox drain (Slice 2 FSD §5.3; Architecture §2.5.1).
///
/// gate (reconciled + online) → read outbox in order → read current row state
/// → convert types (§2.5.3) → idempotent upsert keyed on the UUID v7 PK →
/// delete the outbox row on success. On failure: bookkeeping on the failing
/// row (retry_count / last_attempt_at / last_error), stop (keeps queue
/// order), and report to [SyncHealth] for LG-2 escalation.
///
/// Triggers live in sync_triggers.dart. [run] is safe to call from anywhere:
/// overlapping calls are skipped (in-memory guard — not an outbox column).
class Drain {
  Drain._();

  /// Synced tables only. Outbox entity_type == local table == cloud table.
  static const _syncedTables = {
    'users',
    'per_user_targets',
    'food_entries',
    'saved_items',
    'water_entries',
    'weight_entries',
    'tracked_supplements',
    'supplement_entries',
  };

  /// drift stores DateTime as INTEGER epoch-seconds; cloud is timestamptz.
  static const _timestampCols = {
    'created_at',
    'updated_at',
    'deleted_at',
    'entry_timestamp',
  };

  /// drift stores bool as INTEGER 0/1; cloud is boolean.
  static const _boolCols = {'is_verified'};

  /// Debug-only test hook for criterion 10: run with
  /// `--dart-define=DRAIN_FORCE_FAIL=transient` (or `auth`). Ignored in
  /// release builds.
  static const _forceFail = String.fromEnvironment('DRAIN_FORCE_FAIL');

  static bool _running = false;

  static Future<void> run({String reason = 'manual'}) async {
    if (_running) {
      debugPrint('Drain[$reason]: skipped — already running');
      return;
    }
    _running = true; // set before any await so concurrent triggers skip
    var sent = 0;
    var started = false;
    try {
      if (!cloudConfigured) return;
      if (!await Reconciliation.isReconciled()) {
        debugPrint('Drain[$reason]: gated — not reconciled yet');
        return;
      }
      if (!await isOnline()) {
        debugPrint('Drain[$reason]: gated — offline');
        return; // offline is not a backup failure; doesn't count toward N
      }
      started = true;

      final client = Supabase.instance.client;
      if (client.auth.currentUser == null) {
        // Reconciled but no session: the identity this data belongs to is
        // gone. Never mint a new one (CloudIdentity guard) — escalate.
        await SyncHealth.recordFailure(DrainFailureKind.auth,
            'No cloud session — backup identity needs re-securing');
        return;
      }

      final queue = await db.customSelect(
        'SELECT id, entity_type, entity_id FROM outbox_entries '
        'ORDER BY queued_at, rowid',
      ).get();

      if (kDebugMode && _forceFail.isNotEmpty) {
        final kind = _forceFail == 'auth'
            ? DrainFailureKind.auth
            : DrainFailureKind.transient;
        final msg = 'Forced failure (DRAIN_FORCE_FAIL=$_forceFail)';
        if (queue.isNotEmpty) await _markFailed(queue.first.read('id'), msg);
        debugPrint('Drain[$reason]: FAILED — $msg');
        await SyncHealth.recordFailure(kind, msg);
        return;
      }

      for (final q in queue) {
        final outboxId = q.read<String>('id');
        final table = q.read<String>('entity_type');
        final entityId = q.read<String>('entity_id');

        if (!_syncedTables.contains(table)) {
          debugPrint('Drain: skipping unknown entity_type "$table" — dropped');
          await _dequeue(outboxId);
          continue;
        }

        // Reference-only outbox: read the row's CURRENT state now.
        final rows = await db.customSelect(
          'SELECT * FROM $table WHERE id = ?',
          variables: [Variable.withString(entityId)],
        ).get();
        if (rows.isEmpty) {
          // Can't happen under soft delete; drop rather than block the queue.
          debugPrint('Drain: $table/$entityId not found locally — dropped');
          await _dequeue(outboxId);
          continue;
        }

        try {
          await client.from(table).upsert(_toCloud(rows.first.data));
        } catch (e) {
          final kind = classify(e);
          final msg = _short(e);
          debugPrint('Drain[$reason]: FAILED (${kind.name}) on '
              '$table/$entityId — stopping: $msg');
          await _markFailed(outboxId, msg);
          await SyncHealth.recordFailure(kind, msg);
          return;
        }
        await _dequeue(outboxId);
        sent++;
      }

      // Finished with the queue empty → reset failures / clear escalation.
      await SyncHealth.recordSuccess();
    } catch (e) {
      // Unexpected (local read etc.) — still a failed run once started.
      debugPrint('Drain[$reason]: unexpected error: $e');
      if (started) {
        await SyncHealth.recordFailure(DrainFailureKind.transient, _short(e));
      }
    } finally {
      _running = false;
      if (started) {
        final left = await pendingCount();
        debugPrint('Drain[$reason]: sent $sent, remaining $left');
      }
    }
  }

  /// Pending-backup count (Settings → Backup, FSD G2; Needs-attention item).
  static Future<int> pendingCount() async => (await db
          .customSelect('SELECT COUNT(*) AS n FROM outbox_entries')
          .getSingle())
      .read<int>('n');

  /// Device has a network interface up. Not proof the internet is reachable —
  /// a failed send is simply a normal (transient) failure.
  static Future<bool> isOnline() async =>
      hasNetwork(await Connectivity().checkConnectivity());

  static bool hasNetwork(List<ConnectivityResult> r) =>
      r.any((c) => c != ConnectivityResult.none);

  /// Error classification (FSD §10). Auth/credential → trips LG-2 immediately;
  /// everything else counts toward N.
  static DrainFailureKind classify(Object e) {
    if (e is AuthException) return DrainFailureKind.auth;
    if (e is PostgrestException) {
      const authCodes = {
        '401', '403', // HTTP unauthorized / forbidden
        '42501', // Postgres insufficient_privilege (RLS denial)
        'PGRST301', 'PGRST302', // PostgREST JWT invalid / missing
      };
      if (authCodes.contains(e.code)) return DrainFailureKind.auth;
    }
    return DrainFailureKind.transient;
  }

  static Future<void> _markFailed(String outboxId, String msg) =>
      db.customStatement(
        'UPDATE outbox_entries SET retry_count = retry_count + 1, '
        'last_attempt_at = ?, last_error = ? WHERE id = ?',
        [DateTime.now().millisecondsSinceEpoch ~/ 1000, msg, outboxId],
      );

  static String _short(Object e) {
    final s = e.toString();
    return s.length > 500 ? s.substring(0, 500) : s;
  }

  /// Device row -> cloud row (Architecture §2.5.3 type mapping).
  static Map<String, dynamic> _toCloud(Map<String, Object?> row) {
    return row.map((col, v) {
      if (v == null) return MapEntry(col, null);
      if (_timestampCols.contains(col)) {
        final secs = v as int;
        return MapEntry(
          col,
          DateTime.fromMillisecondsSinceEpoch(secs * 1000, isUtc: true)
              .toIso8601String(),
        );
      }
      if (_boolCols.contains(col)) return MapEntry(col, v == 1);
      return MapEntry(col, v); // uuid text, text, real, integer pass through
    });
  }

  static Future<void> _dequeue(String outboxId) => db.customStatement(
      'DELETE FROM outbox_entries WHERE id = ?', [outboxId]);
}
