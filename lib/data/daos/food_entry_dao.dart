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
