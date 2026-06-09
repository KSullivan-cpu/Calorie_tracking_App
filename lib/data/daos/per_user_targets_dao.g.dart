// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_user_targets_dao.dart';

// ignore_for_file: type=lint
mixin _$PerUserTargetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PerUserTargetsTable get perUserTargets => attachedDatabase.perUserTargets;
  PerUserTargetsDaoManager get managers => PerUserTargetsDaoManager(this);
}

class PerUserTargetsDaoManager {
  final _$PerUserTargetsDaoMixin _db;
  PerUserTargetsDaoManager(this._db);
  $$PerUserTargetsTableTableManager get perUserTargets =>
      $$PerUserTargetsTableTableManager(
        _db.attachedDatabase,
        _db.perUserTargets,
      );
}
