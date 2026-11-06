import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import '../app_database.dart';
import '../enums.dart';
import '../name_key.dart';
import '../tables.dart';

part 'lookup_cache_dao.g.dart';

/// The 8 stored values for one portion (as logged).
class PortionValues {
  final double calories, proteinG, carbsG, fatsG, fiberG, addedSugarG,
      fruitCups, veggieCups;
  const PortionValues({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.addedSugarG,
    required this.fruitCups,
    required this.veggieCups,
  });
}

/// Lookup cache surfaced as "frequent items" (Slice 2 FSD §3.3, §4, §6.4).
/// LOCAL-ONLY: never enqueued (Architecture §1.6). Hard delete on eviction.
/// Writes happen only at commit, inside the commit transaction (FSD §4).
@DriftAccessor(tables: [LookupCacheEntries])
class LookupCacheDao extends DatabaseAccessor<AppDatabase>
    with _$LookupCacheDaoMixin {
  LookupCacheDao(super.db);

  /// Cache bound (FSD §10 tunable, ~50). Tune in Phase 4.
  static const _defaultBound = 50;

  /// Debug-only test hook for criterion 5 (eviction): run with
  /// `--dart-define=CACHE_BOUND=3`. Ignored in release builds.
  static const _boundOverride = int.fromEnvironment('CACHE_BOUND');

  static int get cacheBound =>
      kDebugMode && _boundOverride > 0 ? _boundOverride : _defaultBound;

  SimpleSelectStatement<$LookupCacheEntriesTable, LookupCacheEntry> _ranked(
          String userId) =>
      select(lookupCacheEntries)
        ..where((c) => c.userId.equals(userId))
        ..orderBy([
          (c) => OrderingTerm.desc(c.useCount),
          (c) => OrderingTerm.desc(c.lastUsedAt),
        ]);

  /// Frequent items view order (FSD §3.3): use_count, then last_used_at.
  Future<List<LookupCacheEntry>> ranked(String userId) =>
      _ranked(userId).get();

  Stream<List<LookupCacheEntry>> watchRanked(String userId) =>
      _ranked(userId).watch();

  /// Exact match on [nameKey] (FSD §4 step 3). Null if none.
  Future<LookupCacheEntry?> findByName(String userId, String name) async {
    final key = nameKey(name);
    if (key.isEmpty) return null;
    for (final c in await ranked(userId)) {
      if (nameKey(c.name) == key) return c;
    }
    return null;
  }

  /// FDC-resolved commit (G6): insert (use_count=1) or overwrite values +
  /// bump; then enforce the bound. Values/portion stored as logged (D3).
  Future<void> recordFdcCommit({
    required String userId,
    required String name,
    required double quantity,
    required FoodUnit unit,
    required PortionValues values,
    String? sourceRef,
  }) async {
    final now = DateTime.now();
    final existing = await findByName(userId, name);
    if (existing == null) {
      await into(lookupCacheEntries).insert(LookupCacheEntriesCompanion.insert(
        userId: userId,
        name: name,
        quantity: quantity,
        unit: unit,
        sourceRef: Value(sourceRef),
        useCount: const Value(1),
        lastUsedAt: Value(now),
        calories: Value(values.calories),
        proteinG: Value(values.proteinG),
        carbsG: Value(values.carbsG),
        fatsG: Value(values.fatsG),
        fiberG: Value(values.fiberG),
        addedSugarG: Value(values.addedSugarG),
        fruitCups: Value(values.fruitCups),
        veggieCups: Value(values.veggieCups),
      ));
    } else {
      await _write(existing,
          bump: true, quantity: quantity, unit: unit, values: values,
          sourceRef: sourceRef);
    }
    await _evict(userId);
  }

  /// Frequent-item reuse at commit: bump; if the user edited values without
  /// promoting, write the edited portion in place (FSD §3.1).
  Future<void> recordFrequentUse(
    LookupCacheEntry row, {
    double? quantity,
    FoodUnit? unit,
    PortionValues? editedValues,
  }) =>
      _write(row,
          bump: true,
          quantity: editedValues == null ? null : quantity,
          unit: editedValues == null ? null : unit,
          values: editedValues);

  Future<void> _write(
    LookupCacheEntry row, {
    required bool bump,
    double? quantity,
    FoodUnit? unit,
    PortionValues? values,
    String? sourceRef,
  }) async {
    final v = values;
    await (update(lookupCacheEntries)..where((c) => c.id.equals(row.id)))
        .write(LookupCacheEntriesCompanion(
      useCount: bump ? Value(row.useCount + 1) : const Value.absent(),
      lastUsedAt: bump ? Value(DateTime.now()) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      quantity: quantity == null ? const Value.absent() : Value(quantity),
      unit: unit == null ? const Value.absent() : Value(unit),
      sourceRef: sourceRef == null ? const Value.absent() : Value(sourceRef),
      calories: v == null ? const Value.absent() : Value(v.calories),
      proteinG: v == null ? const Value.absent() : Value(v.proteinG),
      carbsG: v == null ? const Value.absent() : Value(v.carbsG),
      fatsG: v == null ? const Value.absent() : Value(v.fatsG),
      fiberG: v == null ? const Value.absent() : Value(v.fiberG),
      addedSugarG: v == null ? const Value.absent() : Value(v.addedSugarG),
      fruitCups: v == null ? const Value.absent() : Value(v.fruitCups),
      veggieCups: v == null ? const Value.absent() : Value(v.veggieCups),
    ));
  }

  /// Keep the top [cacheBound] by (use_count, last_used_at); hard-delete rest.
  Future<void> _evict(String userId) async {
    final n = await customUpdate(
      'DELETE FROM lookup_cache_entries WHERE user_id = ?1 AND id NOT IN ('
      'SELECT id FROM lookup_cache_entries WHERE user_id = ?1 '
      'ORDER BY use_count DESC, last_used_at DESC LIMIT ?2)',
      variables: [Variable.withString(userId), Variable.withInt(cacheBound)],
      updates: {lookupCacheEntries},
      updateKind: UpdateKind.delete,
    );
    if (n > 0) debugPrint('Cache: evicted $n row(s) (bound $cacheBound)');
  }
}
