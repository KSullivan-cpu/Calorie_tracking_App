import 'food_match.dart';

/// The thin, swappable lookup boundary (FSD §4 step 2, Decision 1).
///
/// One method: search a food name, get back ranked candidates with normalized
/// (per-100g) nutrition. The entry layer auto-picks `[0]`, scales it to the
/// parsed portion, and keeps the rest of the list for change-match.
///
/// Implementations hide their own mechanics — FDC's search→details dance, a
/// future natural-language provider, an offline stub for tests — behind this
/// single call. Nothing downstream knows which provider it's talking to.
abstract class LookupProvider {
  /// Ranked candidates for [query]. Empty list = no match (the manual path).
  /// May throw on network/transport failure; callers treat a thrown error the
  /// same as "no match" in Slice 1 (FSD §4 step 5: fall to manual entry).
  Future<List<FoodMatch>> search(String query);

  /// Enrich [match] with household measures from the source's detail record,
  /// used to size `cup`/`item` portions when the search payload carried none
  /// (FSD §4; Decision 4). Returns [match] unchanged if detail is unavailable
  /// or the source has no usable measures. May throw on transport failure.
  Future<FoodMatch> resolveMeasures(FoodMatch match);
}
