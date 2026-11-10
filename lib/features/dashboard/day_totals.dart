import 'package:calorie_tracking_app/data/app_database.dart';

/// Build-up = hit at least target; stay-under = don't exceed limit (MARD §2.2).
enum MetricKind { buildUp, stayUnder }

/// One dashboard/impact row. `target` null => not tracked (omitted from display).
class MetricRow {
  final String label;
  final double consumed;
  final double? target; // target (build-up) or limit (stay-under); null = untracked
  final String unit;
  final MetricKind kind;

  const MetricRow({
    required this.label,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.kind,
  });

  bool get tracked => target != null;
}

/// Summed nutrient totals across a set of food entries (or in-progress drafts).
class DayTotals {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double addedSugarG;
  final double fruitCups;
  final double veggieCups;

  const DayTotals({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatsG = 0,
    this.fiberG = 0,
    this.addedSugarG = 0,
    this.fruitCups = 0,
    this.veggieCups = 0,
  });
}

const double _kcalPerGramCarbs = 4;
const double _kcalPerGramFats = 9;

/// Stored nutrient values are absolute for the logged portion, so a day total
/// is a plain column sum (Architecture §1 Decision 8).
DayTotals sumEntries(List<FoodEntry> entries) {
  var cal = 0.0,
      pro = 0.0,
      carb = 0.0,
      fat = 0.0,
      fib = 0.0,
      sug = 0.0,
      fruit = 0.0,
      veg = 0.0;
  for (final e in entries) {
    if (!e.isVerified) continue; // unverified counts as zero (FSD §3.7)
    cal += e.calories;
    pro += e.proteinG;
    carb += e.carbsG;
    fat += e.fatsG;
    fib += e.fiberG;
    sug += e.addedSugarG;
    fruit += e.fruitCups;
    veg += e.veggieCups;
  }
  return DayTotals(
    calories: cal,
    proteinG: pro,
    carbsG: carb,
    fatsG: fat,
    fiberG: fib,
    addedSugarG: sug,
    fruitCups: fruit,
    veggieCups: veg,
  );
}

/// Combine two totals (committed today + in-progress drafts -> projected total).
DayTotals addDayTotals(DayTotals a, DayTotals b) => DayTotals(
      calories: a.calories + b.calories,
      proteinG: a.proteinG + b.proteinG,
      carbsG: a.carbsG + b.carbsG,
      fatsG: a.fatsG + b.fatsG,
      fiberG: a.fiberG + b.fiberG,
      addedSugarG: a.addedSugarG + b.addedSugarG,
      fruitCups: a.fruitCups + b.fruitCups,
      veggieCups: a.veggieCups + b.veggieCups,
    );

/// The 8 §2.6 metrics as rows, tracked metrics only.
List<MetricRow> buildMetricRows(List<FoodEntry> entries, PerUserTarget? t) =>
    buildMetricRowsFromTotals(sumEntries(entries), t);

/// Same, but from already-summed totals (used by the projected impact panel).
/// carbs%/fats% computed live against total calories; their limit % reverse-
/// derived from the frozen gram limit + calorie target (B1).
List<MetricRow> buildMetricRowsFromTotals(DayTotals s, PerUserTarget? t) {
  double pctOfCalories(double grams, double kcalPerGram) =>
      s.calories > 0 ? (grams * kcalPerGram / s.calories) * 100 : 0;

  double? limitPct(double? limitGrams, double kcalPerGram) {
    final cal = t?.calorieTarget;
    if (limitGrams == null || cal == null || cal == 0) return null;
    return (limitGrams * kcalPerGram / cal) * 100;
  }

  final rows = <MetricRow>[
    MetricRow(
      label: 'Fruit',
      consumed: s.fruitCups,
      target: t?.fruitCupsTarget,
      unit: 'cups',
      kind: MetricKind.buildUp,
    ),
    MetricRow(
      label: 'Veggies',
      consumed: s.veggieCups,
      target: t?.veggieCupsTarget,
      unit: 'cups',
      kind: MetricKind.buildUp,
    ),
    MetricRow(
      label: 'Protein',
      consumed: s.proteinG,
      target: t?.proteinTarget,
      unit: 'g',
      kind: MetricKind.buildUp,
    ),
    MetricRow(
      label: 'Fiber',
      consumed: s.fiberG,
      target: t?.fiberTarget,
      unit: 'g',
      kind: MetricKind.buildUp,
    ),
    MetricRow(
      label: 'Added sugar',
      consumed: s.addedSugarG,
      target: t?.addedSugarLimit,
      unit: 'g',
      kind: MetricKind.stayUnder,
    ),
    MetricRow(
      label: 'Carbs',
      consumed: pctOfCalories(s.carbsG, _kcalPerGramCarbs),
      target: limitPct(t?.carbsLimitG, _kcalPerGramCarbs),
      unit: '% of cals',
      kind: MetricKind.stayUnder,
    ),
    MetricRow(
      label: 'Fats',
      consumed: pctOfCalories(s.fatsG, _kcalPerGramFats),
      target: limitPct(t?.fatsLimitG, _kcalPerGramFats),
      unit: '% of cals',
      kind: MetricKind.stayUnder,
    ),
    MetricRow(
      label: 'Calories',
      consumed: s.calories,
      target: t?.calorieTarget?.toDouble(),
      unit: 'kcal',
      kind: MetricKind.stayUnder,
    ),
  ];

  return rows.where((r) => r.tracked).toList();
}
