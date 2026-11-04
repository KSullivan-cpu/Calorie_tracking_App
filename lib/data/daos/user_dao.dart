import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getUser() =>
      (select(users)..where((u) => u.deletedAt.isNull())).getSingleOrNull();

  /// Creates the single implicit user if none exists (id = UUID v7), enqueued
  /// in the same transaction (FSD §5.2). Reconciliation later remaps this
  /// outbox entry's entity_id to the cloud uid along with the row itself.
  Future<User> ensureUser() async {
    final existing = await getUser();
    if (existing != null) return existing;
    await transaction(() async {
      final id = genUuidV7();
      await into(users).insert(UsersCompanion(id: Value(id)));
      await enqueue(attachedDatabase, 'users', id, SyncOperation.insert);
    });
    return (await getUser())!;
  }
}
