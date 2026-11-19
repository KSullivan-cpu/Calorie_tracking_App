import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'supplement_entry_dao.g.dart';

/// An active tracked supplement with today's taking count (Stage 3 S1).
class SupplementCount {
  final TrackedSupplement supplement;
  final int count;
  const SupplementCount(this.supplement, this.count);
}

/// Supplement entries (Slice 3 FSD §4, §6.2). One row per taking
/// (Arch Decision 12). Every write and its outbox entry share ONE
/// transaction (Slice 2 FSD §5.2 invariant).
@DriftAccessor(tables: [SupplementEntries, TrackedSupplements])
class SupplementEntryDao extends DatabaseAccessor<AppDatabase>
    with _$SupplementEntryDaoMixin {
  SupplementEntryDao(super.db);

  /// Quick-log Log: one row per ticked supplement, all with the same
  /// timestamp. Returns the new ids so the confirmation's Undo can reverse
  /// exactly this action.
  Future<List<String>> logBatch(String userId, List<String> supplementIds) {
    if (supplementIds.isEmpty) return Future.value(const []);
    return transaction(() async {
      final now = DateTime.now();
      final ids = <String>[];
      for (final sid in supplementIds) {
        final id = genUuidV7();
        await into(supplementEntries).insert(SupplementEntriesCompanion.insert(
          id: Value(id),
          userId: userId,
          entryTimestamp: now,
          supplementId: sid,
        ));
        await enqueue(
            attachedDatabase, 'supplement_entries', id, SyncOperation.insert);
        ids.add(id);
      }
      return ids;
    });
  }

  /// Undo (Slice 3 FSD §3.1, D4) — not a general delete path: soft-deletes
  /// only the rows the last Log wrote. Bumps updated_at + version and
  /// enqueues each, in one transaction.
  Future<void> undo(List<String> ids) => transaction(() async {
        final now = DateTime.now();
        for (final id in ids) {
          final row = await (select(supplementEntries)
                ..where((e) => e.id.equals(id)))
              .getSingleOrNull();
          if (row == null || row.deletedAt != null) continue;
          await (update(supplementEntries)..where((e) => e.id.equals(id)))
              .write(SupplementEntriesCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(row.version + 1),
          ));
          await enqueue(attachedDatabase, 'supplement_entries', id,
              SyncOperation.update);
        }
      });

  /// Active supplements A–Z, each with its count for the local-midnight day
  /// bucket (soft-deleted entries excluded). One source for the quick-log
  /// screen and the dashboard so order and counts always match (FSD §3.4).
  Stream<List<SupplementCount>> watchDayCounts(
      String userId, DateTime dayStart) {
    final dayEnd = dayStart.add(const Duration(days: 1));
    final taken = supplementEntries.id.count();
    final q = select(trackedSupplements).join([
      leftOuterJoin(
        supplementEntries,
        supplementEntries.supplementId.equalsExp(trackedSupplements.id) &
            supplementEntries.deletedAt.isNull() &
            supplementEntries.entryTimestamp.isBiggerOrEqualValue(dayStart) &
            supplementEntries.entryTimestamp.isSmallerThanValue(dayEnd),
      ),
    ])
      ..addColumns([taken])
      ..where(trackedSupplements.userId.equals(userId) &
          trackedSupplements.deletedAt.isNull())
      ..groupBy([trackedSupplements.id])
      ..orderBy([OrderingTerm.asc(trackedSupplements.name.lower())]);
    return q.watch().map((rows) => rows
        .map((r) => SupplementCount(
            r.readTable(trackedSupplements), r.read(taken) ?? 0))
        .toList());
  }
}
