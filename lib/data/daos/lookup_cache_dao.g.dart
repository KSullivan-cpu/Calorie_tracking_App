// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$LookupCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $LookupCacheEntriesTable get lookupCacheEntries =>
      attachedDatabase.lookupCacheEntries;
  LookupCacheDaoManager get managers => LookupCacheDaoManager(this);
}

class LookupCacheDaoManager {
  final _$LookupCacheDaoMixin _db;
  LookupCacheDaoManager(this._db);
  $$LookupCacheEntriesTableTableManager get lookupCacheEntries =>
      $$LookupCacheEntriesTableTableManager(
        _db.attachedDatabase,
        _db.lookupCacheEntries,
      );
}
