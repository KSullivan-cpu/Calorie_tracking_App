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
