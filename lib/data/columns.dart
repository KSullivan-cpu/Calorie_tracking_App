import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'enums.dart';

final _uuid = const Uuid();
String genUuidV7() => _uuid.v7();

/// id + created_at + updated_at â€” on EVERY entity table (incl. User and Lookup cache).
/// Also makes the TEXT uuid `id` the primary key.
mixin BaseColumns on Table {
  TextColumn get id => text().clientDefault(genUuidV7)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// user_id FK -> User. On every entity table EXCEPT User itself (Â§1.2).
mixin UserScoped on Table {
  TextColumn get userId => text()();
}

/// deleted_at soft-delete (Â§1.2). Omitted on Lookup cache (hard-delete on eviction).
mixin SoftDeletable on Table {
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// version â€” v2 conflict-detection primitive (Â§1.2 / Â§2.5.2); written-not-read in v1.
/// Omitted on Lookup cache (local-only, never synced).
mixin Versioned on Table {
  IntColumn get version => integer().withDefault(const Constant(1))();
}

/// entry_timestamp â€” entry/event class only (Â§1.2).
mixin EntryEvent on Table {
  DateTimeColumn get entryTimestamp => dateTime()();
}

/// Portion + the 8 Â§2.6 metric columns. Shared by Food entry, Saved item, Lookup cache.
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
