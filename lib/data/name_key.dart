/// Exact-match key for saved items + lookup cache (Slice 2 FSD §4 steps 2–3;
/// §10 "matching normalization"; Stage 4 D1, 2026-11-05).
///
/// Lowercase → drop apostrophes → other punctuation to spaces → collapse
/// whitespace → trim → singularize the LAST word ("Bananas" == "banana",
/// "Ritz's crackers" == "ritz cracker"). Compared in Dart over the stored rows
/// (tables are small); no schema column.
String nameKey(String s) {
  var t = s
      .toLowerCase()
      .replaceAll(RegExp(r"['’]"), '')
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (t.isEmpty) return t;
  final words = t.split(' ');
  words[words.length - 1] = _singular(words.last);
  return words.join(' ');
}

String _singular(String w) {
  if (w.length > 3 && w.endsWith('ies')) return '${w.substring(0, w.length - 3)}y';
  if (w.length > 3 && w.endsWith('oes')) return w.substring(0, w.length - 2);
  if (w.length > 1 && w.endsWith('s') && !w.endsWith('ss')) {
    return w.substring(0, w.length - 1);
  }
  return w;
}
