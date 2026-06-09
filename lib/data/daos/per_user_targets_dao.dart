import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'per_user_targets_dao.g.dart';

@DriftAccessor(tables: [PerUserTargets])
class PerUserTargetsDao extends DatabaseAccessor<AppDatabase>
    with _$PerUserTargetsDaoMixin {
  PerUserTargetsDao(super.db);

  Future<PerUserTarget?> getTargets(String userId) =>
      (select(perUserTargets)
            ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull()))
          .getSingleOrNull();

  Stream<PerUserTarget?> watchTargets(String userId) =>
      (select(perUserTargets)
            ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull()))
          .watchSingleOrNull();

  /// Insert-or-update the single 1:1 targets row; bumps updatedAt + version on update.
  Future<void> saveTargets(PerUserTargetsCompanion entry) async {
    final existing = await getTargets(entry.userId.value);
    if (existing == null) {
      await into(perUserTargets).insert(entry);
    } else {
      await (update(perUserTargets)..where((t) => t.id.equals(existing.id))).write(
        entry.copyWith(
          updatedAt: Value(DateTime.now()),
          version: Value(existing.version + 1),
        ),
      );
    }
  }
}
