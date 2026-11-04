import 'package:drift/drift.dart' show Variable;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured, db;
import 'reconciliation.dart';

/// Outbox drain — THIN-THREAD version (Slice 2 FSD §5.3; Architecture §2.5.1).
///
/// In scope now: gate → read outbox in order → read current row state →
/// convert types (§2.5.3) → idempotent upsert keyed on the UUID v7 PK →
/// delete the outbox row on success.
///
/// Deferred to the fill-out stage: event + periodic triggers, retry_count /
/// last_attempt_at / last_error bookkeeping, LG-2 escalation, error
/// classification. For now: one run per launch; stop at the first failure
/// (keeps queue order) and try again next launch.
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

  static bool _running = false;

  static Future<void> run() async {
    if (_running) return;
    if (!cloudConfigured) return;
    if (!await Reconciliation.isReconciled()) {
      debugPrint('Drain: gated — not reconciled yet');
      return;
    }
    final client = Supabase.instance.client;
    if (client.auth.currentUser == null) {
      debugPrint('Drain: gated — no cloud session');
      return;
    }

    _running = true;
    var sent = 0;
    try {
      final queue = await db.customSelect(
        'SELECT id, entity_type, entity_id FROM outbox_entries '
        'ORDER BY queued_at, rowid',
      ).get();
      if (queue.isEmpty) {
        debugPrint('Drain: queue empty');
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
          debugPrint('Drain: FAILED on $table/$entityId — stopping, '
              'retry next launch: $e');
          return;
        }
        await _dequeue(outboxId);
        sent++;
      }
    } finally {
      _running = false;
      final left = await db
          .customSelect('SELECT COUNT(*) AS n FROM outbox_entries')
          .getSingle();
      debugPrint('Drain: sent $sent, remaining ${left.read<int>('n')}');
    }
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
