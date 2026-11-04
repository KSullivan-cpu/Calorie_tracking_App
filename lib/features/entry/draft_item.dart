import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/data/lookup/food_match.dart';

/// Working state for one row in the review list (Decision 2): editable values +
/// the ranked candidate list + which one is selected. Owns its TextEditing
/// controllers; the screen disposes them when the row is removed.
class DraftItem {
  final nameCtl = TextEditingController();
  final qtyCtl = TextEditingController(text: '1');
  final calCtl = TextEditingController();
  final proteinCtl = TextEditingController();
  final carbsCtl = TextEditingController();
  final fatsCtl = TextEditingController();
  final fiberCtl = TextEditingController();
  final sugarCtl = TextEditingController();
  final fruitCtl = TextEditingController();
  final veggieCtl = TextEditingController();

  FoodUnit unit;
  List<FoodMatch> candidates;
  int selectedIndex; // -1 = none / manual
  String? status;
  double lastQty; // for proportional rescale on qty change
  final bool initiallyExpanded;

  DraftItem({this.unit = FoodUnit.item, this.initiallyExpanded = true})
      : candidates = const [],
        selectedIndex = -1,
        lastQty = 1;

  void dispose() {
    for (final c in [
      nameCtl,
      qtyCtl,
      calCtl,
      proteinCtl,
      carbsCtl,
      fatsCtl,
      fiberCtl,
      sugarCtl,
      fruitCtl,
      veggieCtl,
    ]) {
      c.dispose();
    }
  }
}
