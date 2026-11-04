enum ProduceClass { fruit, veggie }

/// One bundled produce reference row (Decision 5).
///
/// `gramsPerCup` is the always-present density. `gramsPerItem` is optional —
/// present for countable produce (apple, banana), absent for berries / leafy
/// greens that are only logged by cup or weight.
class ProduceEntry {
  final String name;
  final List<String> aliases;
  final ProduceClass cls;
  final double gramsPerCup;
  final double? gramsPerItem;

  const ProduceEntry({
    required this.name,
    this.aliases = const [],
    required this.cls,
    required this.gramsPerCup,
    this.gramsPerItem,
  });

  bool get countable => gramsPerItem != null;
}
