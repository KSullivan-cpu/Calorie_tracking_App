/// Stored as enum .name (TEXT) per Architecture & Schema Â§2.4 â€” stable across reordering.
enum MealType { breakfast, lunch, snack, dinner }

/// Food entry input-unit set (schema unit set: cups / g / oz / item; MARD Â§1.1).
enum FoodUnit { cups, g, oz, item }

/// Tracked supplement list type (MARD Â§5.5.5). Stored names: dailyTarget / asNeeded.
enum SupplementType { dailyTarget, asNeeded }

/// Outbox operation (Architecture & Schema Â§1.3). `delete` is retained but unused in v1.
enum SyncOperation { insert, update, delete }
