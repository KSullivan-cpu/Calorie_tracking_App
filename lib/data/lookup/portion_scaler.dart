import 'package:calorie_tracking_app/data/enums.dart';

import 'food_match.dart';

const double gramsPerOz = 28.3495;

/// The 6 macro/nutrient values scaled to a specific portion (absolute, not /100g).
/// fruit/veggie cups are not here — the produce reference owns those (Decision 5).
class ScaledNutrition {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double addedSugarG;

  const ScaledNutrition({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatsG = 0,
    this.fiberG = 0,
    this.addedSugarG = 0,
  });
}

/// Resolve a portion's grams from a match + parsed unit (Decision 4).
///
/// `g`/`oz` are exact. `cup`/`item` are best-effort against the match's
/// household measures; returns null when grams can't be determined, so the
/// caller leaves the fields blank for manual entry (FSD §4 step 5). For produce,
/// the caller supplies grams from the seeded list instead of calling this.
double? resolveGramsFromMatch(FoodMatch m, double qty, FoodUnit unit) {
  switch (unit) {
    case FoodUnit.g:
      return qty;
    case FoodUnit.oz:
      return qty * gramsPerOz;
    case FoodUnit.cups:
      final g = _firstMeasureGram(m, _cupKeywords);
      return g == null ? null : qty * g;
    case FoodUnit.item:
      final g = _firstMeasureGram(m, _itemKeywords) ??
          _defaultItemGrams(m.description);
      return g == null ? null : qty * g;
  }
}

const _cupKeywords = ['cup'];
const _itemKeywords = [
  'each',
  'medium',
  'large',
  'small',
  'whole',
  'fruit',
  'piece',
  'slice',
];

/// Fallback grams-per-item for common discrete foods whose source ships no
/// household measure (search payload empty + detail lookup unavailable). Only
/// stable countables — produce is sized by the produce reference, not here.
const _itemDefaultGrams = <String, double>{
  'egg': 50,
  'bacon': 10,
  'bread': 28,
  'toast': 28,
  'tortilla': 30,
  'sausage': 25,
  'waffle': 35,
  'pancake': 40,
};

double? _defaultItemGrams(String description) {
  final d = description.toLowerCase();
  for (final e in _itemDefaultGrams.entries) {
    if (d.contains(e.key)) return e.value;
  }
  return null;
}

double? _firstMeasureGram(FoodMatch m, List<String> keywords) {
  for (final meas in m.measures) {
    final d = meas.description.toLowerCase();
    if (keywords.any(d.contains)) return meas.gramWeight;
  }
  // Best-effort fallback: a lone measure is probably the right one.
  if (m.measures.length == 1) return m.measures.first.gramWeight;
  return null;
}

/// Scale a match's per-100g values to [grams].
ScaledNutrition scaleByGrams(FoodMatch m, double grams) {
  final f = grams / 100.0;
  return ScaledNutrition(
    calories: m.caloriesPer100g * f,
    proteinG: m.proteinPer100g * f,
    carbsG: m.carbsPer100g * f,
    fatsG: m.fatsPer100g * f,
    fiberG: m.fiberPer100g * f,
    addedSugarG: m.addedSugarPer100g * f,
  );
}
