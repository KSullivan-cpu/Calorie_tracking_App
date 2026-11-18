import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'tracked_supplement_dao.g.dart';

/// Tracked supplement list (Slice 3 FSD §3.2, §6.3). Add / edit / soft-delete;
/// every write and its outbox entry share ONE transaction (Slice 2 FSD §5.2).
/// Soft delete keeps the row so past Supplement entries still resolve it.
@DriftAccessor(tables: [TrackedSupplements])
class TrackedSupplementDao extends DatabaseAccessor<AppDatabase>
    with _$TrackedSupplementDaoMixin {
  TrackedSupplementDao(super.db);

  /// Duplicate-name key (FSD §3.2, G3): case-folded, trimmed, inner spaces
  /// collapsed. Deliberately NOT the food `nameKey()` (it singularizes).
  static String key(String name) =>
      name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// Active supplements, A–Z (D6).
  Stream<List<TrackedSupplement>> watchActive(String userId) =>
      (select(trackedSupplements)
            ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.name.lower())]))
          .watch();

  /// True when another ACTIVE supplement already has this name.
  Future<bool> nameTaken(String userId, String name, {String? excludeId}) async {
    final rows = await (select(trackedSupplements)
          ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull()))
        .get();
    final k = key(name);
    return rows.any((r) => r.id != excludeId && key(r.name) == k);
  }

  Future<String> add(
    String userId, {
    required String name,
    required SupplementType type,
    int? dailyTargetCount,
  }) =>
      transaction(() async {
        final id = genUuidV7();
        await into(trackedSupplements).insert(TrackedSupplementsCompanion.insert(
          id: Value(id),
          userId: userId,
          name: name,
          type: type,
          dailyTargetCount: Value(
              type == SupplementType.dailyTarget ? dailyTargetCount : null),
        ));
        await enqueue(
            attachedDatabase, 'tracked_supplements', id, SyncOperation.insert);
        return id;
      });

  /// Edit name / type / target (D6). Switching to as-needed clears the count.
  Future<void> edit(
    TrackedSupplement s, {
    required String name,
    required SupplementType type,
    int? dailyTargetCount,
  }) =>
      transaction(() async {
        await (update(trackedSupplements)..where((t) => t.id.equals(s.id)))
            .write(TrackedSupplementsCompanion(
          name: Value(name),
          type: Value(type),
          dailyTargetCount: Value(
              type == SupplementType.dailyTarget ? dailyTargetCount : null),
          updatedAt: Value(DateTime.now()),
          version: Value(s.version + 1),
        ));
        await enqueue(attachedDatabase, 'tracked_supplements', s.id,
            SyncOperation.update);
      });

  Future<void> softDelete(TrackedSupplement s) => transaction(() async {
        final now = DateTime.now();
        await (update(trackedSupplements)..where((t) => t.id.equals(s.id)))
            .write(TrackedSupplementsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(s.version + 1),
        ));
        await enqueue(attachedDatabase, 'tracked_supplements', s.id,
            SyncOperation.update);
      });
}
