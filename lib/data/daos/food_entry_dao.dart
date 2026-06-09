import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'food_entry_dao.g.dart';

@DriftAccessor(tables: [FoodEntries])
class FoodEntryDao extends DatabaseAccessor<AppDatabase> with _$FoodEntryDaoMixin {
  FoodEntryDao(super.db);

  /// Commit. One row per item; caller shares meal_type + entry_timestamp across a batch.
  Future<void> insertEntries(List<FoodEntriesCompanion> entries) =>
      batch((b) => b.insertAll(foodEntries, entries));

  /// Live committed entries for a local-midnight day bucket (dashboard totals, Â§3.4).
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
