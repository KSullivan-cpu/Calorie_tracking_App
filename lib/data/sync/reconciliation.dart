import 'package:drift/drift.dart' show Variable;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured, db;
import '../app_database.dart';
import '../enums.dart';

/// Identity reconciliation + one-time outbox seed (Slice 2 FSD §5.1, G10).
///
/// Timing (build decision 2026-11-04, "A1"): runs at the START of a launch,
/// before any screen is built, once a cloud identity has been established on
/// an earlier launch. The anonymous uid is read from the persisted session, so
/// this needs no network and takes a moment. Doing it pre-UI means no screen
/// ever holds the stale local user id.
///
/// The rewrite is an identity remap, not a user edit: `updated_at` / `version`
/// are deliberately NOT bumped (build decision 2026-11-04).
class Reconciliation {
  Reconciliation._();

  /// App-local state (FSD §6.7) — shared_preferences, not the schema.
  static const flagKey = 'reconciled_v1';

  /// One-time catch-up for devices reconciled BEFORE the §5.2 enqueue
  /// invariant existed (rows written in that gap were never enqueued).
  static const catchUpKey = 'outbox_catchup_v1';

  /// Synced tables (Architecture §1.6), in seed order: parents before
  /// children (tracked_supplements before supplement_entries). Outbox
  /// `entity_type` = the table name, which is also the cloud table name.
  static const _syncedTables = [
    'per_user_targets',
    'food_entries',
    'saved_items',
    'water_entries',
    'weight_entries',
    'tracked_supplements',
    'supplement_entries',
  ];

  /// Every user-scoped table — the synced ones plus the local-only cache,
  /// whose user_id is rewritten too (FSD §6.4) but which is never enqueued.
  static const _userScopedTables = [..._syncedTables, 'lookup_cache_entries'];

  static Future<bool> isReconciled() async =>
      (await SharedPreferences.getInstance()).getBool(flagKey) ?? false;

  /// Never throws; any failure leaves the device as it was and retries on
  /// the next launch.
  static Future<void> runIfNeeded() async {
    if (!cloudConfigured) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(flagKey) ?? false) return;

    final cloudId = Supabase.instance.client.auth.currentUser?.id;
    if (cloudId == null) {
      debugPrint('Reconciliation: no cloud identity yet — skipped this launch');
      return;
    }

    final localId = (await db.userDao.getUser())!.id;
    final seeded = <String, int>{};

    try {
      await db.transaction(() async {
        // 1. Rewrite: local uid -> anonymous uid. Skipped when already equal
        //    (a crash after commit but before the flag was set).
        if (localId != cloudId) {
          await db.customStatement(
              'UPDATE users SET id = ? WHERE id = ?', [cloudId, localId]);
          for (final t in _userScopedTables) {
            await db.customStatement(
                'UPDATE $t SET user_id = ? WHERE user_id = ?',
                [cloudId, localId]);
          }
          // The User row's own outbox entry points at its id — remap it too.
          await db.customStatement(
              "UPDATE outbox_entries SET entity_id = ? "
              "WHERE entity_type = 'users' AND entity_id = ?",
              [cloudId, localId]);
        }

        // 2. One-time seed: every existing synced row, User first. A repeat
        //    seed (crash-retry) only adds harmless duplicate upserts.
        seeded.addAll(await _seedAll(cloudId));
      });

      // 3. Flag only after the transaction committed. A fresh reconcile
      //    already covers everything, so the catch-up isn't needed.
      await prefs.setBool(flagKey, true);
      await prefs.setBool(catchUpKey, true);
      debugPrint('Reconciliation: DONE  $localId -> $cloudId');
      debugPrint('Reconciliation: seeded outbox $seeded');
    } catch (e) {
      debugPrint('Reconciliation: FAILED (rolled back; retry next launch): $e');
    }
  }

  /// One-time catch-up (build note 2026-11-04): this device reconciled before
  /// the enqueue invariant existed, so rows written in between were never
  /// enqueued. Re-enqueue every synced row once; already-backed-up rows just
  /// re-upsert identically (idempotent). Never throws.
  static Future<void> catchUpIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(flagKey) ?? false)) return; // reconcile seeds instead
    if (prefs.getBool(catchUpKey) ?? false) return;
    try {
      final uid = (await db.userDao.getUser())!.id;
      late Map<String, int> seeded;
      await db.transaction(() async => seeded = await _seedAll(uid));
      await prefs.setBool(catchUpKey, true);
      debugPrint('Outbox catch-up: DONE $seeded');
    } catch (e) {
      debugPrint('Outbox catch-up: FAILED (retry next launch): $e');
    }
  }

  /// Enqueue every synced row for [uid], User first. Call inside a transaction.
  static Future<Map<String, int>> _seedAll(String uid) async {
    final seeded = <String, int>{};
    await _enqueue('users', [uid]);
    seeded['users'] = 1;
    for (final t in _syncedTables) {
      final rows = await db.customSelect(
        'SELECT id FROM $t WHERE user_id = ?',
        variables: [Variable.withString(uid)],
      ).get();
      final ids = rows.map((r) => r.read<String>('id')).toList();
      await _enqueue(t, ids);
      seeded[t] = ids.length;
    }
    return seeded;
  }

  static Future<void> _enqueue(String entityType, List<String> ids) async {
    for (final id in ids) {
      await db.into(db.outboxEntries).insert(OutboxEntriesCompanion.insert(
            entityType: entityType,
            entityId: id,
            operation: SyncOperation.insert,
          ));
    }
  }
}
