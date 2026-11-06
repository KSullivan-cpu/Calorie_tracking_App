import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/name_key.dart';
import 'package:calorie_tracking_app/features/library/save_to_library.dart';

/// Frequent items view (Slice 2 FSD §3.3, G7): the lookup cache, browsable,
/// ranked by use_count then last_used_at. Rows: name, base portion, calories,
/// source. Row action "Save to library" saves immediately (no entry commit).
/// Not a pick surface; not in Settings.
class FrequentItemsScreen extends StatelessWidget {
  final String userId;
  const FrequentItemsScreen({super.key, required this.userId});

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  /// Cache rows are FDC-resolved only (G6); `source_ref` = `fdc:<id>`.
  static String _source(LookupCacheEntry c) {
    final ref = c.sourceRef ?? '';
    return ref.startsWith('fdc:') || ref.isEmpty ? 'FDC' : ref;
  }

  Future<void> _save(BuildContext context, LookupCacheEntry c) async {
    final t = await chooseSaveTarget(
      context,
      userId: userId,
      initialName: c.name,
      hint: 'Saves now with this item\'s portion and values.',
    );
    if (t == null) return;
    // Replace = soft-delete + insert, both enqueued, one transaction (G5).
    await db.transaction(() async {
      if (t.replaces != null) await db.savedItemDao.softDelete(t.replaces!);
      await db.savedItemDao.insertItem(SavedItemsCompanion.insert(
        userId: userId,
        name: t.name,
        quantity: c.quantity,
        unit: c.unit,
        calories: Value(c.calories),
        proteinG: Value(c.proteinG),
        carbsG: Value(c.carbsG),
        fatsG: Value(c.fatsG),
        fiberG: Value(c.fiberG),
        addedSugarG: Value(c.addedSugarG),
        fruitCups: Value(c.fruitCups),
        veggieCups: Value(c.veggieCups),
      ));
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved "${t.name}" to your library')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frequent items')),
      body: StreamBuilder<List<SavedItem>>(
        stream: db.savedItemDao.watchActive(userId),
        builder: (context, sSnap) {
          final savedKeys = {
            for (final s in sSnap.data ?? const <SavedItem>[]) nameKey(s.name)
          };
          return StreamBuilder<List<LookupCacheEntry>>(
            stream: db.lookupCacheDao.watchRanked(userId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = snap.data!;
              if (rows.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No frequent items yet.\n'
                      'Foods you log from an online lookup show up here.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = rows[i];
                  final saved = savedKeys.contains(nameKey(c.name));
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                      '${_fmt(c.quantity)} ${c.unit.name} · '
                      '${_fmt(c.calories)} kcal · ${_source(c)}',
                    ),
                    trailing: saved
                        ? const Chip(
                            avatar: Icon(Icons.check, size: 16),
                            label: Text('Saved'),
                            visualDensity: VisualDensity.compact,
                          )
                        : TextButton(
                            onPressed: () => _save(context, c),
                            child: const Text('Save to library'),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
