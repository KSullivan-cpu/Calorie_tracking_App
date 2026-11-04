import 'package:calorie_tracking_app/data/enums.dart';

/// One parsed line: a food name + quantity + unit (Decision 3).
class ParsedItem {
  final String name;
  final double qty;
  final FoodUnit unit;
  const ParsedItem({required this.name, required this.qty, required this.unit});
}

/// Split a comma-delimited string into parsed items. Empty names are dropped.
List<ParsedItem> parseEntry(String input) => input
    .split(',')
    .map(_parseOne)
    .where((p) => p.name.isNotEmpty)
    .toList(growable: false);

final _numUnit = RegExp(r'^(\d*\.?\d+)\s*([a-zA-Z]+)?\s*');
final _numOnly = RegExp(r'^(\d*\.?\d+)\s*');
final _aPrefix = RegExp(r'^(a|an)\s+', caseSensitive: false);

/// Leading counting nouns / fillers that shouldn't reach the lookup query:
/// "slices (of) white bread" -> "white bread", "of egg whites" -> "egg whites".
final _fillerPrefix = RegExp(
    r'^(?:(?:slices?|pieces?)\s+(?:of\s+)?|of\s+)',
    caseSensitive: false);

String _stripLeadingFiller(String name) {
  final m = _fillerPrefix.firstMatch(name);
  return m == null ? name : name.substring(m.end).trim();
}

ParsedItem _parseOne(String raw) {
  final original = raw.trim();
  if (original.isEmpty) {
    return const ParsedItem(name: '', qty: 1, unit: FoodUnit.item);
  }

  var s = original;
  double qty = 1;
  FoodUnit unit = FoodUnit.item;

  final a = _aPrefix.firstMatch(s);
  if (a != null) {
    // "a"/"an" -> qty 1, then an optional unit word ("a cup rice")
    s = s.substring(a.end);
    final lead = _leadingUnit(s);
    if (lead != null) {
      unit = lead.unit;
      s = s.substring(lead.length);
    }
  } else {
    final m = _numUnit.firstMatch(s);
    if (m != null) {
      qty = double.tryParse(m.group(1)!) ?? 1;
      final mapped = _unitFromToken(m.group(2)?.toLowerCase());
      if (m.group(2) != null && mapped != null) {
        // recognised unit token (spaced or glued, e.g. "12oz")
        unit = mapped;
        s = s.substring(m.end);
      } else {
        // number only; any trailing word is part of the name ("2 eggs")
        s = original.substring(_numOnly.firstMatch(original)!.end);
        unit = FoodUnit.item;
      }
    }
    // no leading number -> qty 1, item, whole string is the name
  }

  final name = _stripLeadingFiller(s.trim());
  return ParsedItem(name: name, qty: qty, unit: unit);
}

class _UnitToken {
  final FoodUnit unit;
  final int length;
  _UnitToken(this.unit, this.length);
}

_UnitToken? _leadingUnit(String s) {
  final m = RegExp(r'^([a-zA-Z]+)\s+').firstMatch(s);
  if (m == null) return null;
  final u = _unitFromToken(m.group(1)!.toLowerCase());
  return u == null ? null : _UnitToken(u, m.end);
}

FoodUnit? _unitFromToken(String? t) {
  switch (t) {
    case 'g':
    case 'gram':
    case 'grams':
      return FoodUnit.g;
    case 'oz':
    case 'ounce':
    case 'ounces':
      return FoodUnit.oz;
    case 'cup':
    case 'cups':
      return FoodUnit.cups;
    default:
      return null;
  }
}
