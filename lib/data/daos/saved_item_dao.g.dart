// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_item_dao.dart';

// ignore_for_file: type=lint
mixin _$SavedItemDaoMixin on DatabaseAccessor<AppDatabase> {
  $SavedItemsTable get savedItems => attachedDatabase.savedItems;
  SavedItemDaoManager get managers => SavedItemDaoManager(this);
}

class SavedItemDaoManager {
  final _$SavedItemDaoMixin _db;
  SavedItemDaoManager(this._db);
  $$SavedItemsTableTableManager get savedItems =>
      $$SavedItemsTableTableManager(_db.attachedDatabase, _db.savedItems);
}
