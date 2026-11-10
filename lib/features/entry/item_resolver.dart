import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/data/lookup/food_match.dart';
import 'package:calorie_tracking_app/data/lookup/lookup_provider.dart';
import 'package:calorie_tracking_app/data/lookup/portion_scaler.dart';
import 'package:calorie_tracking_app/data/produce/produce_entry.dart';
import 'package:calorie_tracking_app/data/produce/produce_reference.dart';

/// Result of an online lookup (Slice 2 Stage 5a, decision A3).
///
/// [unreachable] = the source could not be asked (device offline, or every
/// attempt threw — timeout, transport error, repeated HTTP 400). Only then is
/// soft-commit offered (FSD §4). A completed search with no results is a plain
/// no-match (Manual, as in Slice 1). Judged per item.
class LookupOutcome {
  final List<FoodMatch> matches;
  final bool unreachable;
  const LookupOutcome(this.matches) : unreachable = false;
  const LookupOutcome.unreachable()
      : matches = const [],
        unreachable = true;
}

/// Search candidates for [name]. If the query returns nothing usable, retry
/// once with a singular form, since FDC is literal about plurals ("egg whites"
/// -> 0, "egg white" -> results).
///
/// A throw on the first search = unreachable. A throw on the singular retry
/// keeps the first search's results if it had any; otherwise unreachable (the
/// lookup never completed).
Future<LookupOutcome> lookupCandidates(
  LookupProvider provider,
  String name,
) async {
  List<FoodMatch> results;
  try {
    results = await provider.search(name);
  } catch (_) {
    return const LookupOutcome.unreachable();
  }
  final unusable = results.isEmpty || results.first.caloriesPer100g == 0;
  if (unusable) {
    final singular = _singularize(name);
    if (singular != name.trim()) {
      try {
        final alt = await provider.search(singular);
        if (alt.isNotEmpty && alt.first.caloriesPer100g > 0) results = alt;
      } catch (_) {
        if (results.isEmpty) return const LookupOutcome.unreachable();
      }
    }
  }
  return LookupOutcome(results);
}

String _singularize(String s) {
  final t = s.trim();
  final lower = t.toLowerCase();
  if (lower.endsWith('ies') && t.length > 3) {
    return '${t.substring(0, t.length - 3)}y';
  }
  if (lower.endsWith('s') && !lower.endsWith('ss')) {
    return t.substring(0, t.length - 1);
  }
  return t;
}

/// The values a resolved item should show. Nulls mean "couldn't fill — manual".
class ItemFill {
  final ScaledNutrition? macros;
  final double? fruitCups;
  final double? veggieCups;
  final String status;
  const ItemFill({
    this.macros,
    this.fruitCups,
    this.veggieCups,
    required this.status,
  });
}

/// Compute an item's fill from a chosen match + produce entry at (qty, unit).
/// Pure — used both on first resolve (top candidate) and on change-match,
/// without re-searching. Produce is the sizing authority when it matches.
ItemFill fillFor({
  required ProduceReference produceRef,
  ProduceEntry? produceEntry,
  FoodMatch? match,
  required double qty,
  required FoodUnit unit,
}) {
  double? grams;
  double? fruitCups;
  double? veggieCups;

  if (produceEntry != null) {
    final pr = produceRef.resolve(produceEntry, qty, unit);
    grams = pr.grams;
    if (pr.cups != null) {
      if (pr.cls == ProduceClass.fruit) {
        fruitCups = pr.cups;
      } else {
        veggieCups = pr.cups;
      }
    }
  } else if (match != null) {
    grams = resolveGramsFromMatch(match, qty, unit);
  }

  final macros = (match != null && grams != null)
      ? scaleByGrams(match, grams)
      : null;

  final String status;
  if (produceEntry != null && macros != null) {
    status = 'FDC macros + produce cups';
  } else if (produceEntry != null && grams != null) {
    status = 'Produce cups; macros manual';
  } else if (produceEntry != null) {
    status = 'Log by cup or weight';
  } else if (macros != null) {
    status = match!.description;
  } else if (match != null) {
    status = "Matched, but couldn't size — manual";
  } else {
    status = 'No match — manual';
  }

  return ItemFill(
    macros: macros,
    fruitCups: fruitCups,
    veggieCups: veggieCups,
    status: status,
  );
}

/// Like [fillFor], but for a non-produce `cup`/`item` match that can't be sized
/// from the search payload's measures, makes one on-demand detail call
/// ([LookupProvider.resolveMeasures]) to fetch household measures, then sizes.
/// No extra call for produce, `g`/`oz`, or matches that already size.
Future<ItemFill> fillForWithMeasures({
  required LookupProvider provider,
  required ProduceReference produceRef,
  ProduceEntry? produceEntry,
  FoodMatch? match,
  required double qty,
  required FoodUnit unit,
}) async {
  var m = match;
  final needsMeasures =
      produceEntry == null &&
      m != null &&
      (unit == FoodUnit.cups || unit == FoodUnit.item) &&
      resolveGramsFromMatch(m, qty, unit) == null;
  if (needsMeasures) {
    try {
      m = await provider.resolveMeasures(m);
    } catch (_) {
      // leave m as-is; fillFor falls to the manual status
    }
  }
  return fillFor(
    produceRef: produceRef,
    produceEntry: produceEntry,
    match: m,
    qty: qty,
    unit: unit,
  );
}
