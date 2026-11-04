/// A normalized lookup result from any provider (Decision 1).
///
/// Nutrition is expressed **per 100 g** so the entry layer can scale it to the
/// parsed portion (Decision 4). The 6 macro/nutrient values come from the
/// provider; `fruit_cups` / `veggie_cups` do NOT — those are filled separately
/// from the seeded produce reference (Decision 5).
///
/// `measures` carries the source's household measures (e.g. "1 large" = 50 g),
/// which let `cup` / `item` input units resolve to grams (Decision 4, §4 step 3).
class FoodMatch {
  /// Food label as the source describes it (shown in the change-match list).
  final String description;

  /// Provider's own id (e.g. FDC `fdcId`). Kept for detail fetches / debugging.
  final String? sourceId;

  // --- 6 nutrient values, per 100 g ---
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final double fiberPer100g;
  final double addedSugarPer100g; // often absent in FDC -> 0

  /// Source household measures, each with a gram weight for one unit.
  final List<HouseholdMeasure> measures;

  const FoodMatch({
    required this.description,
    this.sourceId,
    this.caloriesPer100g = 0,
    this.proteinPer100g = 0,
    this.carbsPer100g = 0,
    this.fatsPer100g = 0,
    this.fiberPer100g = 0,
    this.addedSugarPer100g = 0,
    this.measures = const [],
  });

  /// Returns a copy with [measures] replaced (used to enrich a search-result
  /// match with household measures fetched from the source's detail record).
  FoodMatch copyWith({List<HouseholdMeasure>? measures}) => FoodMatch(
        description: description,
        sourceId: sourceId,
        caloriesPer100g: caloriesPer100g,
        proteinPer100g: proteinPer100g,
        carbsPer100g: carbsPer100g,
        fatsPer100g: fatsPer100g,
        fiberPer100g: fiberPer100g,
        addedSugarPer100g: addedSugarPer100g,
        measures: measures ?? this.measures,
      );
}

/// One household measure for a food: a free-text description + the gram weight
/// of a single unit of it (FDC `foodPortions`). Used to resolve cup/item units.
class HouseholdMeasure {
  /// e.g. "1 large", "1 cup, chopped", "1 fruit without skin and seeds".
  final String description;

  /// Grams for ONE of this measure (qty is applied by the scaler).
  final double gramWeight;

  const HouseholdMeasure({
    required this.description,
    required this.gramWeight,
  });
}
