// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplement_entry_dao.dart';

// ignore_for_file: type=lint
mixin _$SupplementEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $TrackedSupplementsTable get trackedSupplements =>
      attachedDatabase.trackedSupplements;
  $SupplementEntriesTable get supplementEntries =>
      attachedDatabase.supplementEntries;
  SupplementEntryDaoManager get managers => SupplementEntryDaoManager(this);
}

class SupplementEntryDaoManager {
  final _$SupplementEntryDaoMixin _db;
  SupplementEntryDaoManager(this._db);
  $$TrackedSupplementsTableTableManager get trackedSupplements =>
      $$TrackedSupplementsTableTableManager(
        _db.attachedDatabase,
        _db.trackedSupplements,
      );
  $$SupplementEntriesTableTableManager get supplementEntries =>
      $$SupplementEntriesTableTableManager(
        _db.attachedDatabase,
        _db.supplementEntries,
      );
}
