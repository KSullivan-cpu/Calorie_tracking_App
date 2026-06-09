import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getUser() =>
      (select(users)..where((u) => u.deletedAt.isNull())).getSingleOrNull();

  /// Creates the single implicit user if none exists (id = UUID v7 via clientDefault).
  Future<User> ensureUser() async {
    final existing = await getUser();
    if (existing != null) return existing;
    await into(users).insert(const UsersCompanion());
    return (await getUser())!;
  }
}
