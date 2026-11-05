import 'package:drift/drift.dart';
import '../app_database.dart';
import '../columns.dart' show genUuidV7;
import '../enums.dart';
import '../name_key.dart';
import '../sync/outbox.dart';
import '../tables.dart';

part 'saved_item_dao.g.dart';

/// Saved-items library (Slice 2 FSD §3.1–§3.2, §6.3). Synced: every write is
/// enqueued in the same transaction (FSD §5.2). Soft delete only.
@DriftAccessor(tables: [SavedItems])
class SavedItemDao extends DatabaseAccessor<AppDatabase>
    with _$SavedItemDaoMixin {
  SavedItemDao(super.db);

  SimpleSelectStatement<$SavedItemsTable, SavedItem> _active(String userId) =>
      select(savedItems)
        ..where((s) => s.userId.equals(userId) & s.deletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.asc(s.name.lower())]);

  Future<List<SavedItem>> activeItems(String userId) => _active(userId).get();

  Stream<List<SavedItem>> watchActive(String userId) =>
      _active(userId).watch();

  /// Exact match on [nameKey] (FSD §4 step 2). Null if none.
  Future<SavedItem?> findByName(String userId, String name) async {
    final key = nameKey(name);
    if (key.isEmpty) return null;
    for (final s in await activeItems(userId)) {
      if (nameKey(s.name) == key) return s;
    }
    return null;
  }

  /// Insert + enqueue. Returns the new id.
  Future<String> insertItem(SavedItemsCompanion entry) =>
      transaction(() async {
        final row =
            entry.id.present ? entry : entry.copyWith(id: Value(genUuidV7()));
        await into(savedItems).insert(row);
        await enqueue(
            attachedDatabase, 'saved_items', row.id.value, SyncOperation.insert);
        return row.id.value;
      });

  /// Soft delete + enqueue (delete mode, and "Replace?" in G5).
  Future<void> softDelete(SavedItem item) => transaction(() async {
        final now = DateTime.now();
        await (update(savedItems)..where((s) => s.id.equals(item.id))).write(
          SavedItemsCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
            version: Value(item.version + 1),
          ),
        );
        await enqueue(
            attachedDatabase, 'saved_items', item.id, SyncOperation.update);
      });
}
