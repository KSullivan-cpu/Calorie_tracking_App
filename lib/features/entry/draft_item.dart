import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/data/lookup/food_match.dart';

/// Where a card's values came from (Slice 2 FSD §3.1). Entry-time display
/// only — never stored (Architecture §1 Decision 9).
enum ItemSource {
  saved('Saved'),
  frequent('Frequent'),
  fdc('FDC'),
  manual('Manual');

  final String label;
  const ItemSource(this.label);
}

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

  // --- Slice 2 (Stage 4) ---
  ItemSource source = ItemSource.manual;

  /// False when the user typed no quantity (parser). Saved/cache matches then
  /// fill at the item's base portion.
  bool hasQty = true;

  /// Set when a Saved/Frequent match had a non-convertible unit (G4).
  bool unitMismatch = false;

  /// The cache row a Frequent card came from (bumped/updated at commit).
  LookupCacheEntry? cacheRow;

  /// User typed into a nutrient field after the fill (D5 promote prompt;
  /// in-place cache update on commit). Qty rescale is NOT an edit.
  bool valuesEdited = false;

  /// "Save to library" marked (FSD §3.1). Saves on commit, as logged, under
  /// [saveName]. [replaces] = the existing item the user agreed to replace
  /// (G5); it is soft-deleted at commit.
  bool saveToLibrary = false;
  String? saveName;
  SavedItem? replaces;

  // --- Slice 2 (Stage 5) ---

  /// The online lookup for this card couldn't reach FDC (A3; per item).
  /// Soft-commit is offered only on these cards (FSD §4).
  bool unreachable = false;

  /// "Log as unverified" switch (B hybrid). Defaults on for an unreachable
  /// card; typing a nutrient value turns it off (= manual entry). Commits as
  /// `is_verified=false` with zero values (Stage 5b).
  bool logUnverified = false;

  DraftItem({this.unit = FoodUnit.item, this.initiallyExpanded = true})
      : candidates = const [],
        selectedIndex = -1,
        lastQty = 1;

  List<TextEditingController> get valueCtls => [
        calCtl,
        proteinCtl,
        carbsCtl,
        fatsCtl,
        fiberCtl,
        sugarCtl,
        fruitCtl,
        veggieCtl,
      ];

  void dispose() {
    for (final c in [nameCtl, qtyCtl, ...valueCtls]) {
      c.dispose();
    }
  }
}
