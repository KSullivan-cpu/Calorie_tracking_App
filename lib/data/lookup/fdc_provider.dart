import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import 'food_match.dart';
import 'lookup_provider.dart';

/// USDA FoodData Central implementation of [LookupProvider] (Decision 1).
///
/// One network call per search: GET /foods/search. Search-result nutrients are
/// matched by FDC's stable nutrient *number* (the search payload nests them as
/// either `nutrientNumber`/`value` or `number`/`amount`) and treated as per-100g.
/// Candidates are scored so the auto-picked top match is the plain whole food
/// with real nutrients, not an empty entry or a processed variant. The full
/// scored list is returned for change-match.
///
/// The API key comes from the compile-time environment (`--dart-define=
/// FDC_API_KEY=...`) so it never lives in the repo. Empty key => empty results.
class FdcProvider implements LookupProvider {
  FdcProvider({
    this.apiKey = const String.fromEnvironment('FDC_API_KEY'),
    this.pageSize = 25,
    http.Client? client,
  }) : _injectedClient = client;

  final String apiKey;
  final int pageSize;

  /// Test seam: when supplied, this client is reused (and never closed here).
  /// In production it stays null and every [search] uses a fresh client that is
  /// closed afterward — USDA's nginx drops idle keep-alive connections, and
  /// reusing a stale socket yields intermittent nginx HTTP 400s.
  final http.Client? _injectedClient;

  static const _base = 'https://api.nal.usda.gov/fdc/v1/foods/search';
  static const _detailBase = 'https://api.nal.usda.gov/fdc/v1/food';
  static const _maxAttempts = 3; // 1 attempt + 2 retries
  static const _userAgent = 'CalorieTrackingApp/0.1 (personal use)';

  // FDC nutrient numbers (stable across data releases).
  static const _nCalories = '208';
  static const _nProtein = '203';
  static const _nCarbs = '205';
  static const _nFats = '204';
  static const _nFiber = '291';
  static const _nAddedSugar = '539';

  // Description words that signal a processed/non-base variant.
  static const _processed = [
    'dried', 'dehydrated', 'chip', 'juice', 'fried', 'sweetened', 'canned',
    'sauce', 'powder', 'baby food', 'cooked', 'frozen', 'jam', 'jelly',
    'syrup', 'candied', 'roasted', 'smoked', 'cured', 'breaded',
  ];

  @override
  Future<List<FoodMatch>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty || apiKey.isEmpty) return const [];

    final uri = Uri.parse(_base).replace(queryParameters: {
      'api_key': apiKey,
      'query': q,
      'pageSize': '$pageSize',
      'dataType': 'Foundation,SR Legacy,Survey (FNDDS),Branded',
    });

    final raw = await _getWithRetry(uri, q);

    final body = jsonDecode(raw) as Map<String, dynamic>;
    final foods =
        ((body['foods'] as List?) ?? const []).whereType<Map<String, dynamic>>().toList();

    debugPrint('FDC "$q" -> ${foods.length} results');

    // Score then sort (desc), with original-index tiebreak for stability.
    final indexed = [for (var i = 0; i < foods.length; i++) (i, foods[i])];
    indexed.sort((a, b) {
      final s = _score(b.$2, q).compareTo(_score(a.$2, q));
      return s != 0 ? s : a.$1.compareTo(b.$1);
    });

    // Dedupe by description (case-insensitive), keeping the highest-scored.
    final seen = <String>{};
    final out = <FoodMatch>[];
    for (final e in indexed) {
      final m = _toMatch(e.$2);
      if (seen.add(m.description.toLowerCase().trim())) out.add(m);
    }
    return out;
  }

  @override
  Future<FoodMatch> resolveMeasures(FoodMatch match) async {
    final id = match.sourceId;
    if (id == null || id.isEmpty || match.measures.isNotEmpty || apiKey.isEmpty) {
      return match;
    }

    final uri = Uri.parse('$_detailBase/$id')
        .replace(queryParameters: {'api_key': apiKey});

    try {
      final raw = await _getWithRetry(uri, 'detail $id');
      final body = jsonDecode(raw) as Map<String, dynamic>;
      final measures = <HouseholdMeasure>[];
      for (final p in (body['foodPortions'] as List?) ?? const []) {
        if (p is! Map) continue;
        final g = p['gramWeight'];
        if (g is! num) continue;
        final unitName =
            (p['measureUnit'] is Map) ? p['measureUnit']['name'] : null;
        final desc =
            (p['portionDescription'] ?? p['modifier'] ?? unitName ?? '')
                .toString();
        measures.add(
            HouseholdMeasure(description: desc, gramWeight: g.toDouble()));
      }
      return measures.isEmpty ? match : match.copyWith(measures: measures);
    } catch (_) {
      return match;
    }
  }

  /// GET with a fresh connection per attempt + bounded retry. USDA's nginx
  /// intermittently returns HTTP 400 when a stale keep-alive socket is reused,
  /// so each attempt uses its own client (closed after) and transient failures
  /// retry with a short backoff. Throws if every attempt fails (→ manual path).
  Future<String> _getWithRetry(Uri uri, String q) async {
    Object? lastError;
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      final client = _injectedClient ?? http.Client();
      try {
        final res = await client.get(uri, headers: const {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        });
        if (res.statusCode == 200) return res.body;
        final snippet =
            res.body.length > 200 ? res.body.substring(0, 200) : res.body;
        debugPrint('FDC "$q" attempt $attempt -> HTTP ${res.statusCode}: $snippet');
        lastError = Exception('FDC search failed (HTTP ${res.statusCode})');
        if (res.statusCode == 404) break; // deterministic not-found; don't retry
      } catch (e) {
        debugPrint('FDC "$q" attempt $attempt -> $e');
        lastError = e;
      } finally {
        if (_injectedClient == null) client.close();
      }
      if (attempt < _maxAttempts) {
        await Future<void>.delayed(Duration(milliseconds: 200 * attempt));
      }
    }
    throw lastError ?? Exception('FDC search failed');
  }

  double _nutrient(List nutrients, String number) {
    for (final raw in nutrients) {
      if (raw is! Map) continue;
      final numStr = (raw['nutrientNumber'] ?? raw['number'])?.toString();
      if (numStr == number) {
        final v = raw['value'] ?? raw['amount'];
        if (v is num) return v.toDouble();
      }
    }
    return 0;
  }

  double _score(Map<String, dynamic> f, String query) {
    final desc = (f['description'] ?? '').toString().toLowerCase();
    final nutrients = (f['foodNutrients'] as List?) ?? const [];
    final calories = _nutrient(nutrients, _nCalories);

    double s = 0;

    s += switch ((f['dataType'] ?? '').toString()) {
      'Foundation' || 'SR Legacy' => 100,
      'Survey (FNDDS)' => 60,
      'Branded' => 20,
      _ => 0,
    };

    // Usable nutrition is the biggest factor — never auto-pick an empty entry.
    s += calories > 0 ? 50 : -200;

    if (desc == query) s += 40;
    if (desc.startsWith(query)) s += 20;
    if (desc.contains(query)) s += 10;
    if (desc.contains('raw')) s += 15;

    // Head-noun match: strongly prefer the plain food whose name *is* the query
    // ("Eggs, Grade A") over a high-data-type compound that merely contains the
    // word ("Bread, egg"). FDC names whole foods primary-noun-first. S/plural aware.
    String singular(String w) =>
        (w.endsWith('s') && !w.endsWith('ss')) ? w.substring(0, w.length - 1) : w;
    final qHead =
        singular(query.toLowerCase().trim().split(RegExp(r'\s+')).first);
    final descTokens =
        desc.split(RegExp(r'[^a-z]+')).where((t) => t.isNotEmpty);
    final dHead = descTokens.isEmpty ? '' : singular(descTokens.first);
    if (dHead.isNotEmpty && dHead == qHead) s += 150;

    for (final w in _processed) {
      if (desc.contains(w)) s -= 25;
    }

    s -= desc.length * 0.05; // plainer (shorter) descriptions edge ahead
    return s;
  }

  FoodMatch _toMatch(Map<String, dynamic> f) {
    final nutrients = (f['foodNutrients'] as List?) ?? const [];

    final measures = <HouseholdMeasure>[];
    for (final raw in (f['foodMeasures'] as List?) ?? const []) {
      if (raw is! Map) continue;
      final g = raw['gramWeight'];
      if (g is num) {
        measures.add(HouseholdMeasure(
          description:
              (raw['disseminationText'] ?? raw['modifier'] ?? '').toString(),
          gramWeight: g.toDouble(),
        ));
      }
    }

    return FoodMatch(
      description: (f['description'] ?? '').toString(),
      sourceId: f['fdcId']?.toString(),
      caloriesPer100g: _nutrient(nutrients, _nCalories),
      proteinPer100g: _nutrient(nutrients, _nProtein),
      carbsPer100g: _nutrient(nutrients, _nCarbs),
      fatsPer100g: _nutrient(nutrients, _nFats),
      fiberPer100g: _nutrient(nutrients, _nFiber),
      addedSugarPer100g: _nutrient(nutrients, _nAddedSugar),
      measures: measures,
    );
  }
}
