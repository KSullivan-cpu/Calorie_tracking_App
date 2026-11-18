import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'water_entry_dao.g.dart';

/// Water entries (Slice 3 FSD §4, §6.1). Amounts are **oz** (MARD v1.0.3
/// §5.5.4). Every write and its outbox entry share ONE transaction
/// (Slice 2 FSD §5.2 invariant).
@DriftAccessor(tables: [WaterEntries])
class WaterEntryDao extends DatabaseAccessor<AppDatabase>
    with _$WaterEntryDaoMixin {
  WaterEntryDao(super.db);

  /// Quick-log Add: one row, timestamp = now. Returns the new id so the
  /// confirmation's Undo can reverse exactly this action.
  Future<String> add(String userId, double amountOz) => transaction(() async {
        final id = genUuidV7();
        await into(waterEntries).insert(WaterEntriesCompanion.insert(
          id: Value(id),
          userId: userId,
          entryTimestamp: DateTime.now(),
          amount: amountOz,
        ));
        await enqueue(
            attachedDatabase, 'water_entries', id, SyncOperation.insert);
        return id;
      });

  /// Undo (Slice 3 FSD §3.1, D4) — the ONE post-commit change in Slice 3.
  /// Not a general delete path: soft-deletes only the rows the last action
  /// wrote. Bumps updated_at + version and enqueues each, in one transaction.
  Future<void> undo(List<String> ids) => transaction(() async {
        final now = DateTime.now();
        for (final id in ids) {
          final row = await (select(waterEntries)
                ..where((w) => w.id.equals(id)))
              .getSingleOrNull();
          if (row == null || row.deletedAt != null) continue;
          await (update(waterEntries)..where((w) => w.id.equals(id))).write(
            WaterEntriesCompanion(
              deletedAt: Value(now),
              updatedAt: Value(now),
              version: Value(row.version + 1),
            ),
          );
          await enqueue(
              attachedDatabase, 'water_entries', id, SyncOperation.update);
        }
      });

  /// Live total (oz) for a local-midnight day bucket; soft-deleted excluded.
  Stream<double> watchDayTotal(String userId, DateTime dayStart) {
    final dayEnd = dayStart.add(const Duration(days: 1));
    final total = waterEntries.amount.sum();
    final q = selectOnly(waterEntries)
      ..addColumns([total])
      ..where(waterEntries.userId.equals(userId) &
          waterEntries.deletedAt.isNull() &
          waterEntries.entryTimestamp.isBiggerOrEqualValue(dayStart) &
          waterEntries.entryTimestamp.isSmallerThanValue(dayEnd));
    return q.map((r) => r.read(total) ?? 0.0).watchSingle();
  }
}
