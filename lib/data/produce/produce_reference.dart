import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:calorie_tracking_app/data/enums.dart';
import 'produce_entry.dart';

const double _gramsPerOz = 28.3495;

/// Result of sizing a produce entry to a portion: grams (for FDC macro scaling)
/// + cups (for the fruit/veggie metric). Either is null when the unit can't be
/// resolved (e.g. "item" on a non-countable produce).
class ProduceResolution {
  final double? grams;
  final double? cups;
  final ProduceClass cls;
  const ProduceResolution({this.grams, this.cups, required this.cls});
}

/// The bundled, read-only seeded produce reference (Decision 5). Loaded once at
/// startup from `assets/produce.json`. Authoring forms accepted per row:
///   countable:     { cupsPerItem, gramsPerItem }   (grams-per-cup derived)
///   non-countable: { gramsPerCup }                 (e.g. berries, greens)
/// `gramsPerItem` may also be supplied alongside `gramsPerCup` for countables.
class ProduceReference {
  final Map<String, ProduceEntry> _byKey;
  ProduceReference._(this._byKey);

  static Future<ProduceReference> load([
    String assetPath = 'assets/produce.json',
  ]) async {
    final raw = await rootBundle.loadString(assetPath);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final byKey = <String, ProduceEntry>{};

    for (final m in list) {
      final cupsPerItem = (m['cupsPerItem'] as num?)?.toDouble();
      final gramsPerItem = (m['gramsPerItem'] as num?)?.toDouble();
      final explicit = (m['gramsPerCup'] as num?)?.toDouble();
      final gramsPerCup = explicit ??
          ((gramsPerItem != null && cupsPerItem != null && cupsPerItem != 0)
              ? gramsPerItem / cupsPerItem
              : null);
      if (gramsPerCup == null) continue; // malformed row -> skip

      final entry = ProduceEntry(
        name: (m['name'] as String).trim(),
        aliases: ((m['aliases'] as List?) ?? const [])
            .map((a) => a.toString())
            .toList(),
        cls: (m['class'] == 'fruit') ? ProduceClass.fruit : ProduceClass.veggie,
        gramsPerCup: gramsPerCup,
        gramsPerItem: gramsPerItem,
      );
      byKey[_norm(entry.name)] = entry;
      for (final a in entry.aliases) {
        byKey[_norm(a)] = entry;
      }
    }
    return ProduceReference._(byKey);
  }

  static String _norm(String s) => s.toLowerCase().trim();

  /// Match a parsed food name: exact (incl. aliases), simple plural strip, then
  /// a contains check (longest keys first) so "fresh blueberries" still matches.
  ProduceEntry? match(String foodName) {
    final n = _norm(foodName);
    if (n.isEmpty) return null;

    final exact = _byKey[n];
    if (exact != null) return exact;

    if (n.endsWith('s')) {
      final singular = _byKey[n.substring(0, n.length - 1)];
      if (singular != null) return singular;
    }

    final keys = _byKey.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in keys) {
      if (n.contains(key)) return _byKey[key];
    }
    return null;
  }

  /// Size an entry to (qty, unit): grams for macro scaling + cups for the metric.
  ProduceResolution resolve(ProduceEntry e, double qty, FoodUnit unit) {
    double? grams;
    switch (unit) {
      case FoodUnit.g:
        grams = qty;
      case FoodUnit.oz:
        grams = qty * _gramsPerOz;
      case FoodUnit.cups:
        grams = qty * e.gramsPerCup;
      case FoodUnit.item:
        grams = e.gramsPerItem == null ? null : qty * e.gramsPerItem!;
    }
    final cups = grams == null ? null : grams / e.gramsPerCup;
    return ProduceResolution(grams: grams, cups: cups, cls: e.cls);
  }
}
