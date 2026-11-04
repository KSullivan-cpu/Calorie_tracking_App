import 'package:calorie_tracking_app/data/enums.dart';

/// Default meal-type from the clock (FSD §3.5: sensible default + override).
/// Band boundaries are a build-level tunable (FSD §9) — placeholder values here.
MealType defaultMealType(DateTime now) {
  final h = now.hour;
  if (h < 11) return MealType.breakfast; // before 11:00
  if (h < 15) return MealType.lunch; //     11:00–14:59
  if (h < 17) return MealType.snack; //     15:00–16:59
  return MealType.dinner; //                17:00+
}

/// Display label for a meal-type (UI only).
String mealTypeLabel(MealType m) => switch (m) {
      MealType.breakfast => 'Breakfast',
      MealType.lunch => 'Lunch',
      MealType.snack => 'Snack',
      MealType.dinner => 'Dinner',
    };