# setup_schema.ps1 — run from C:\dev\calorie_tracking_app
if (-not (Test-Path "pubspec.yaml")) { Write-Error "Run this from the repo root (pubspec.yaml not found)."; exit 1 }

New-Item -ItemType Directory -Force -Path "lib\data\daos" | Out-Null

Set-Content -Path "lib\data\enums.dart" -Encoding UTF8 -Value @'
/// Stored as enum .name (TEXT) per Architecture & Schema §2.4 — stable across reordering.
enum MealType { breakfast, lunch, snack, dinner }

/// Food entry input-unit set (schema unit set: cups / g / oz / item; MARD §1.1).
enum FoodUnit { cups, g, oz, item }

/// Tracked supplement list type (MARD §5.5.5). Stored names: dailyTarget / asNeeded.
enum SupplementType { dailyTarget, asNeeded }

/// Outbox operation (Architecture & Schema §1.3). `delete` is retained but unused in v1.
enum SyncOperation { insert, update, delete }
'@

Set-Content -Path "lib\data\columns.dart" -Encoding UTF8 -Value @'
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'enums.dart';

final _uuid = const Uuid();
String genUuidV7() => _uuid.v7();

/// id + created_at + updated_at — on EVERY entity table (incl. User and Lookup cache).
/// Also makes the TEXT uuid `id` the primary key.
mixin BaseColumns on Table {
  TextColumn get id => text().clientDefault(genUuidV7)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// user_id FK -> User. On every entity table EXCEPT User itself (§1.2).
mixin UserScoped on Table {
  TextColumn get userId => text()();
}

/// deleted_at soft-delete (§1.2). Omitted on Lookup cache (hard-delete on eviction).
mixin SoftDeletable on Table {
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// version — v2 conflict-detection primitive (§1.2 / §2.5.2); written-not-read in v1.
/// Omitted on Lookup cache (local-only, never synced).
mixin Versioned on Table {
  IntColumn get version => integer().withDefault(const Constant(1))();
}

/// entry_timestamp — entry/event class only (§1.2).
mixin EntryEvent on Table {
  DateTimeColumn get entryTimestamp => dateTime()();
}

/// Portion + the 8 §2.6 metric columns. Shared by Food entry, Saved item, Lookup cache.
mixin NutritionColumns on Table {
  RealColumn get quantity    => real()();
  TextColumn get unit        => textEnum<FoodUnit>()();
  RealColumn get calories    => real().withDefault(const Constant(0))();
  RealColumn get proteinG    => real().withDefault(const Constant(0))();
  RealColumn get carbsG      => real().withDefault(const Constant(0))();
  RealColumn get fatsG       => real().withDefault(const Constant(0))();
  RealColumn get fiberG      => real().withDefault(const Constant(0))();
  RealColumn get addedSugarG => real().withDefault(const Constant(0))();
  RealColumn get fruitCups   => real().withDefault(const Constant(0))();
  RealColumn get veggieCups  => real().withDefault(const Constant(0))();
}
'@

Set-Content -Path "lib\data\tables.dart" -Encoding UTF8 -Value @'
import 'package:drift/drift.dart';
import 'enums.dart';
import 'columns.dart';

class Users extends Table with BaseColumns, SoftDeletable, Versioned {}

class PerUserTargets extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned {
  IntColumn  get calorieTarget    => integer().nullable()();
  RealColumn get proteinTarget    => real().nullable()();
  RealColumn get fiberTarget      => real().nullable()();
  RealColumn get fruitCupsTarget  => real().nullable()();
  RealColumn get veggieCupsTarget => real().nullable()();
  RealColumn get addedSugarLimit  => real().nullable()();
  RealColumn get carbsLimitG      => real().nullable()();
  RealColumn get fatsLimitG       => real().nullable()();
  RealColumn get waterTarget      => real().nullable()();
  RealColumn get weightTarget     => real().nullable()();
}

class FoodEntries extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned, EntryEvent, NutritionColumns {
  TextColumn get name       => text()();
  TextColumn get mealType   => textEnum<MealType>()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(true))();
}

class WaterEntries extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned, EntryEvent {
  RealColumn get amount => real()();
}

class WeightEntries extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned, EntryEvent {
  RealColumn get weight => real()();
}

class TrackedSupplements extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned {
  TextColumn get name             => text()();
  TextColumn get type             => textEnum<SupplementType>()();
  IntColumn  get dailyTargetCount => integer().nullable()();
}

class SupplementEntries extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned, EntryEvent {
  TextColumn get supplementId =>
      text().references(TrackedSupplements, #id)();
}

class SavedItems extends Table
    with BaseColumns, UserScoped, SoftDeletable, Versioned, NutritionColumns {
  TextColumn get name => text()();
}

class LookupCacheEntries extends Table
    with BaseColumns, UserScoped, NutritionColumns {
  TextColumn     get name       => text()();
  TextColumn     get sourceRef  => text().nullable()();
  IntColumn      get useCount   => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsedAt => dateTime().clientDefault(() => DateTime.now())();
}

class OutboxEntries extends Table {
  TextColumn     get id            => text().clientDefault(genUuidV7)();
  TextColumn     get entityType    => text()();
  TextColumn     get entityId      => text()();
  TextColumn     get operation     => textEnum<SyncOperation>()();
  DateTimeColumn get queuedAt      => dateTime().clientDefault(() => DateTime.now())();
  IntColumn      get retryCount    => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn     get lastError     => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
'@

Set-Content -Path "lib\data\app_database.dart" -Encoding UTF8 -Value @'
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';
import 'daos/user_dao.dart';
import 'daos/per_user_targets_dao.dart';
import 'daos/food_entry_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users, PerUserTargets, FoodEntries,
    WaterEntries, WeightEntries,
    TrackedSupplements, SupplementEntries,
    SavedItems, LookupCacheEntries,
    OutboxEntries,
  ],
  daos: [UserDao, PerUserTargetsDao, FoodEntryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'calorie_tracking'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();

          await customStatement('CREATE INDEX idx_food_entries_user_time '
              'ON food_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_water_entries_user_time '
              'ON water_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_weight_entries_user_time '
              'ON weight_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_supp_entries_user_time '
              'ON supplement_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_supp_entries_supp_time '
              'ON supplement_entries (supplement_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_saved_items_user_name '
              'ON saved_items (user_id, name) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_tracked_supp_user '
              'ON tracked_supplements (user_id) WHERE deleted_at IS NULL');

          await customStatement('CREATE INDEX idx_cache_name '
              'ON lookup_cache_entries (name)');
          await customStatement('CREATE INDEX idx_cache_lfu '
              'ON lookup_cache_entries (use_count, last_used_at)');

          await customStatement('CREATE INDEX idx_outbox_queued '
              'ON outbox_entries (queued_at)');
        },
      );
}
'@

Set-Content -Path "lib\data\daos\user_dao.dart" -Encoding UTF8 -Value @'
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
'@

Set-Content -Path "lib\data\daos\per_user_targets_dao.dart" -Encoding UTF8 -Value @'
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
'@

Set-Content -Path "lib\data\daos\food_entry_dao.dart" -Encoding UTF8 -Value @'
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
'@

Set-Content -Path "lib\core\bootstrap.dart" -Encoding UTF8 -Value @'
import 'package:flutter/widgets.dart';
import '../data/app_database.dart';

final db = AppDatabase();

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.userDao.ensureUser();
}
'@

Set-Content -Path "lib\main.dart" -Encoding UTF8 -Value @'
import 'package:flutter/material.dart';
import 'core/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
  final user = await db.userDao.getUser();
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(child: Text('DB OK — user: ${user?.id ?? "none"}')),
    ),
  ));
}
'@

Remove-Item -ErrorAction SilentlyContinue "lib\core\.gitkeep","lib\data\.gitkeep"
Write-Host "`nFiles created. Next, run:" -ForegroundColor Green
Write-Host "  flutter pub add drift drift_flutter uuid"
Write-Host "  flutter pub add dev:drift_dev dev:build_runner"
Write-Host "  dart run build_runner build --delete-conflicting-outputs"
Write-Host "  flutter run"