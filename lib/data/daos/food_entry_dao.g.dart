// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_entry_dao.dart';

// ignore_for_file: type=lint
mixin _$FoodEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $FoodEntriesTable get foodEntries => attachedDatabase.foodEntries;
  FoodEntryDaoManager get managers => FoodEntryDaoManager(this);
}

class FoodEntryDaoManager {
  final _$FoodEntryDaoMixin _db;
  FoodEntryDaoManager(this._db);
  $$FoodEntriesTableTableManager get foodEntries =>
      $$FoodEntriesTableTableManager(_db.attachedDatabase, _db.foodEntries);
}
