import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'food_entry_dao.g.dart';

@DriftAccessor(tables: [FoodEntries])
class FoodEntryDao extends DatabaseAccessor<AppDatabase> with _$FoodEntryDaoMixin {
  FoodEntryDao(super.db);

  /// Commit. One row per item; caller shares meal_type + entry_timestamp across a batch.
  /// Each row and its outbox entry are written in ONE transaction (FSD §5.2).
  /// The id is assigned here so the outbox entry can reference it.
  Future<void> insertEntries(List<FoodEntriesCompanion> entries) =>
      transaction(() async {
        for (final e in entries) {
          final row = e.id.present ? e : e.copyWith(id: Value(genUuidV7()));
          await into(foodEntries).insert(row);
          await enqueue(
              attachedDatabase, 'food_entries', row.id.value, SyncOperation.insert);
        }
      });

  /// Verification review (Slice 2 FSD §3.4, G8) — the ONE post-commit change
  /// allowed in Slice 2 (FSD §2.3 exception). Not a general edit path: it
  /// only ever sets `is_verified=true`, optionally filling the 8 values when
  /// the caller is inside the 7-day window. Bumps `updated_at` + `version` and
  /// enqueues the update in the same transaction (§5.2 invariant).
  Future<void> verify(
    FoodEntry entry, {
    FoodEntriesCompanion? values,
  }) =>
      transaction(() async {
        final now = DateTime.now();
        final base = values ?? const FoodEntriesCompanion();
        await (update(foodEntries)..where((e) => e.id.equals(entry.id)))
            .write(base.copyWith(
          isVerified: const Value(true),
          updatedAt: Value(now),
          version: Value(entry.version + 1),
        ));
        await enqueue(
            attachedDatabase, 'food_entries', entry.id, SyncOperation.update);
      });

  /// Live unverified (soft-committed) entries, oldest first — the
  /// Needs-attention queue's item type 1 (Slice 2 FSD §3.4; Stage 5c).
  Stream<List<FoodEntry>> watchUnverified(String userId) =>
      (select(foodEntries)
            ..where((e) =>
                e.userId.equals(userId) &
                e.deletedAt.isNull() &
                e.isVerified.equals(false))
            ..orderBy([(e) => OrderingTerm.asc(e.entryTimestamp)]))
          .watch();

  /// Live committed entries for a local-midnight day bucket (dashboard totals, §3.4).
  Stream<List<FoodEntry>> watchEntriesForDay(String userId, DateTime dayStart) {
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (select(foodEntries)
          ..where((e) =>
              e.userId.equals(userId) &
              e.deletedAt.isNull() &
              e.entryTimestamp.isBiggerOrEqualValue(dayStart) &
              e.entryTimestamp.isSmallerThanValue(dayEnd)))
        .watch();
  }
}
