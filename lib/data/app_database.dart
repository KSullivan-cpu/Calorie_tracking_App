import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'enums.dart';
import 'columns.dart';
import 'enums.dart';
import 'columns.dart';
import 'tables.dart';
import 'daos/user_dao.dart';
import 'daos/per_user_targets_dao.dart';
import 'daos/food_entry_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users, PerUserTargets, FoodEntries,
    WaterEntries, WeightEntries,
    TrackedSupplements, SupplementEntries,
    SavedItems, LookupCacheEntries,
    OutboxEntries,
  ],
  daos: [UserDao, PerUserTargetsDao, FoodEntryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'calorie_tracking'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();

          await customStatement('CREATE INDEX idx_food_entries_user_time '
              'ON food_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_water_entries_user_time '
              'ON water_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_weight_entries_user_time '
              'ON weight_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_supp_entries_user_time '
              'ON supplement_entries (user_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_supp_entries_supp_time '
              'ON supplement_entries (supplement_id, entry_timestamp) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_saved_items_user_name '
              'ON saved_items (user_id, name) WHERE deleted_at IS NULL');
          await customStatement('CREATE INDEX idx_tracked_supp_user '
              'ON tracked_supplements (user_id) WHERE deleted_at IS NULL');

          await customStatement('CREATE INDEX idx_cache_name '
              'ON lookup_cache_entries (name)');
          await customStatement('CREATE INDEX idx_cache_lfu '
              'ON lookup_cache_entries (use_count, last_used_at)');

          await customStatement('CREATE INDEX idx_outbox_queued '
              'ON outbox_entries (queued_at)');
        },
      );
}
