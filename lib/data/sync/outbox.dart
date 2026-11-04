import '../app_database.dart';
import '../enums.dart';

/// Outbox enqueue invariant (Slice 2 FSD §5.2).
///
/// Call INSIDE the same transaction as the write it records: a synced row
/// without its outbox entry is a silently un-backed-up row. Never call for
/// the lookup cache (local-only, Architecture §1.6).
///
/// `entityType` = the table name (== the cloud table name the drain targets).
Future<void> enqueue(
  AppDatabase db,
  String entityType,
  String entityId,
  SyncOperation op,
) =>
    db.into(db.outboxEntries).insert(OutboxEntriesCompanion.insert(
          entityType: entityType,
          entityId: entityId,
          operation: op,
        ));
