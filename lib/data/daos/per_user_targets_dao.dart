import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
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
  /// The write and its outbox entry share ONE transaction (FSD §5.2).
  Future<void> saveTargets(PerUserTargetsCompanion entry) => transaction(() async {
        final existing = await getTargets(entry.userId.value);
        if (existing == null) {
          final row =
              entry.id.present ? entry : entry.copyWith(id: Value(genUuidV7()));
          await into(perUserTargets).insert(row);
          await enqueue(attachedDatabase, 'per_user_targets', row.id.value,
              SyncOperation.insert);
        } else {
          await (update(perUserTargets)..where((t) => t.id.equals(existing.id)))
              .write(
            entry.copyWith(
              updatedAt: Value(DateTime.now()),
              version: Value(existing.version + 1),
            ),
          );
          await enqueue(attachedDatabase, 'per_user_targets', existing.id,
              SyncOperation.update);
        }
      });
}
