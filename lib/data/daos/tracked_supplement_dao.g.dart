// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracked_supplement_dao.dart';

// ignore_for_file: type=lint
mixin _$TrackedSupplementDaoMixin on DatabaseAccessor<AppDatabase> {
  $TrackedSupplementsTable get trackedSupplements =>
      attachedDatabase.trackedSupplements;
  TrackedSupplementDaoManager get managers => TrackedSupplementDaoManager(this);
}

class TrackedSupplementDaoManager {
  final _$TrackedSupplementDaoMixin _db;
  TrackedSupplementDaoManager(this._db);
  $$TrackedSupplementsTableTableManager get trackedSupplements =>
      $$TrackedSupplementsTableTableManager(
        _db.attachedDatabase,
        _db.trackedSupplements,
      );
}
