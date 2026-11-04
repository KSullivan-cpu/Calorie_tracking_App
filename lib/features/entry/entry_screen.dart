import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/data/lookup/fdc_provider.dart';
import 'package:calorie_tracking_app/data/lookup/lookup_provider.dart';
import 'package:calorie_tracking_app/features/dashboard/day_totals.dart';
import 'package:calorie_tracking_app/features/dashboard/metric_bar.dart';
import 'package:calorie_tracking_app/features/entry/draft_item.dart';
import 'package:calorie_tracking_app/features/entry/item_resolver.dart';
import 'package:calorie_tracking_app/features/entry/meal_time.dart';
import 'package:calorie_tracking_app/features/entry/parser.dart';

/// Stage 2d entry: comma batch -> editable review list, with a persistent
/// impact panel + commit pinned at the bottom. The panel shows the *projected*
/// day total (committed today + in-progress items), live, build-up vs stay-under
/// (Decision 6); commit writes one Food entry per card, shared meal-type + ts.
class EntryScreen extends StatefulWidget {
  final String userId;
  const EntryScreen({super.key, required this.userId});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final LookupProvider _provider = FdcProvider();

  final _input = TextEditingController();
  List<DraftItem> _items = [];
  late MealType _mealType = defaultMealType(DateTime.now());
  bool _parsing = false;
  bool _saving = false;

  late final DateTime _today;
  late final Stream<List<FoodEntry>> _committedStream;
  late final Stream<PerUserTarget?> _targetsStream;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _today = DateTime(n.year, n.month, n.day);
    _committedStream =
        db.foodEntryDao.watchEntriesForDay(widget.userId, _today);
    _targetsStream = db.perUserTargetsDao.watchTargets(widget.userId);
  }

  @override
  void dispose() {
    _input.dispose();
    for (final it in _items) {
      it.dispose();
    }
    super.dispose();
  }

  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  DayTotals _draftTotals() {
    var cal = 0.0,
        pro = 0.0,
        carb = 0.0,
        fat = 0.0,
        fib = 0.0,
        sug = 0.0,
        fr = 0.0,
        vg = 0.0;
    for (final i in _items) {
      cal += _d(i.calCtl);
      pro += _d(i.proteinCtl);
      carb += _d(i.carbsCtl);
      fat += _d(i.fatsCtl);
      fib += _d(i.fiberCtl);
      sug += _d(i.sugarCtl);
      fr += _d(i.fruitCtl);
      vg += _d(i.veggieCtl);
    }
    return DayTotals(
      calories: cal,
      proteinG: pro,
      carbsG: carb,
      fatsG: fat,
      fiberG: fib,
      addedSugarG: sug,
      fruitCups: fr,
      veggieCups: vg,
    );
  }

  void _applyFill(DraftItem item, ItemFill fill) {
    final m = fill.macros;
    if (m != null) {
      item.calCtl.text = _fmt(m.calories);
      item.proteinCtl.text = _fmt(m.proteinG);
      item.carbsCtl.text = _fmt(m.carbsG);
      item.fatsCtl.text = _fmt(m.fatsG);
      item.fiberCtl.text = _fmt(m.fiberG);
      item.sugarCtl.text = _fmt(m.addedSugarG);
    }
    if (fill.fruitCups != null) item.fruitCtl.text = _fmt(fill.fruitCups!);
    if (fill.veggieCups != null) item.veggieCtl.text = _fmt(fill.veggieCups!);
    item.status = fill.status;
  }

  Future<void> _resolve(DraftItem item, {bool preserveOnFailure = false}) async {
    final name = item.nameCtl.text.trim();
    if (name.isEmpty) return;
    final qty = double.tryParse(item.qtyCtl.text.trim()) ?? 1;
    final produceEntry = produce.match(name);
    final candidates = await lookupCandidates(_provider, name);
    // A user-initiated re-search (🔍) that finds nothing must not clobber a good
    // fill: keep candidates, selection, field values, and status as they were.
    if (candidates.isEmpty && preserveOnFailure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results — kept previous match')),
        );
      }
      return;
    }
    item.candidates = candidates;
    item.selectedIndex = candidates.isNotEmpty ? 0 : -1;
    final match = candidates.isNotEmpty ? candidates.first : null;
    final fill = await fillForWithMeasures(
      provider: _provider,
      produceRef: produce,
      produceEntry: produceEntry,
      match: match,
      qty: qty,
      unit: item.unit,
    );
    item.lastQty = qty;
    _applyFill(item, fill);
    if (mounted) setState(() {});
  }

  Future<void> _parse() async {
    final parsed = parseEntry(_input.text);
    if (parsed.isEmpty) return;

    for (final it in _items) {
      it.dispose();
    }
    final items = parsed.map((p) {
      final d = DraftItem(unit: p.unit, initiallyExpanded: false);
      d.nameCtl.text = p.name;
      d.qtyCtl.text = _fmt(p.qty);
      d.lastQty = p.qty;
      d.status = 'Resolving…';
      return d;
    }).toList();

    setState(() {
      _items = items;
      _parsing = true;
      _input.clear();
    });

    for (final item in items) {
      await _resolve(item); // sequential -> avoids FDC throttling
    }
    if (mounted) setState(() => _parsing = false);
  }

  Future<void> _changeMatch(DraftItem item, int index) async {
    if (index < 0 || index >= item.candidates.length) return;
    item.selectedIndex = index;
    final qty = double.tryParse(item.qtyCtl.text.trim()) ?? 1;
    final produceEntry = produce.match(item.nameCtl.text.trim());
    final fill = await fillForWithMeasures(
      provider: _provider,
      produceRef: produce,
      produceEntry: produceEntry,
      match: item.candidates[index],
      qty: qty,
      unit: item.unit,
    );
    if (!mounted) return;
    setState(() => _applyFill(item, fill));
  }

  void _rescaleQty(DraftItem item) {
    final newQty = double.tryParse(item.qtyCtl.text.trim()) ?? 0;
    final oldQty = item.lastQty;
    if (newQty <= 0 || oldQty <= 0 || newQty == oldQty) {
      if (newQty > 0) item.lastQty = newQty;
      return;
    }
    final ratio = newQty / oldQty;
    for (final c in [
      item.calCtl,
      item.proteinCtl,
      item.carbsCtl,
      item.fatsCtl,
      item.fiberCtl,
      item.sugarCtl,
      item.fruitCtl,
      item.veggieCtl,
    ]) {
      final v = double.tryParse(c.text.trim());
      if (v != null) c.text = _fmt(v * ratio);
    }
    item.lastQty = newQty;
    setState(() {});
  }

  void _addItem() => setState(() => _items.add(DraftItem()));

  void _removeItem(DraftItem item) {
    setState(() => _items.remove(item));
    item.dispose();
  }

  Future<void> _commitAll() async {
    final valid =
        _items.where((i) => i.nameCtl.text.trim().isNotEmpty).toList();
    if (valid.isEmpty) return;

    final ts = DateTime.now(); // shared across the batch
    final companions = valid
        .map((i) => FoodEntriesCompanion.insert(
              userId: widget.userId,
              name: i.nameCtl.text.trim(),
              mealType: _mealType,
              quantity: double.tryParse(i.qtyCtl.text.trim()) ?? 1,
              unit: i.unit,
              entryTimestamp: ts,
              calories: Value(_d(i.calCtl)),
              proteinG: Value(_d(i.proteinCtl)),
              carbsG: Value(_d(i.carbsCtl)),
              fatsG: Value(_d(i.fatsCtl)),
              fiberG: Value(_d(i.fiberCtl)),
              addedSugarG: Value(_d(i.sugarCtl)),
              fruitCups: Value(_d(i.fruitCtl)),
              veggieCups: Value(_d(i.veggieCtl)),
            ))
        .toList();

    setState(() => _saving = true);
    await db.foodEntryDao.insertEntries(companions);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log food')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _input,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Items (comma-separated)',
                    hintText: 'e.g. 2 eggs, 1 banana, 100g chicken breast',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<MealType>(
                        initialValue: _mealType,
                        decoration: const InputDecoration(
                          labelText: 'Meal',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: MealType.values
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(mealTypeLabel(m)),
                                ))
                            .toList(),
                        onChanged: (m) =>
                            setState(() => _mealType = m ?? _mealType),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _parsing ? null : _parse,
                      icon: _parsing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.playlist_add),
                      label: const Text('Parse'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              children: [
                ..._items.map(_itemCard),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add item'),
                ),
              ],
            ),
          ),
          _impactPanel(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_saving || _items.isEmpty) ? null : _commitAll,
                child: Text(_saving ? 'Committing…' : 'Commit all'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _impactPanel() {
    return StreamBuilder<PerUserTarget?>(
      stream: _targetsStream,
      builder: (context, tSnap) {
        final targets = tSnap.data;
        return StreamBuilder<List<FoodEntry>>(
          stream: _committedStream,
          builder: (context, cSnap) {
            final committed = cSnap.data ?? const <FoodEntry>[];
            final projected =
                addDayTotals(sumEntries(committed), _draftTotals());
            final rows = buildMetricRowsFromTotals(projected, targets);
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projected today',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  if (rows.isEmpty)
                    Text('No tracked metrics',
                        style: Theme.of(context).textTheme.bodySmall)
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 184),
                      child: ListView(
                        shrinkWrap: true,
                        children: rows.map((r) => MetricBar(r)).toList(),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _itemCard(DraftItem item) {
    final kcal = item.calCtl.text.trim();
    final name = item.nameCtl.text.trim();
    final summary = [
      '${item.qtyCtl.text.trim()} ${item.unit.name}',
      if (kcal.isNotEmpty && kcal != '0') '$kcal kcal',
      if (item.status != null) item.status!,
    ].join('  ·  ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        key: ValueKey(item),
        initiallyExpanded: item.initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(name.isEmpty ? '(unnamed)' : name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(summary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: item.nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                tooltip: 'Look up',
                icon: const Icon(Icons.search),
                onPressed: () => _resolve(item, preserveOnFailure: true),
              ),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeItem(item),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: item.qtyCtl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  onEditingComplete: () => _rescaleQty(item),
                  onSubmitted: (_) => _rescaleQty(item),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<FoodUnit>(
                  initialValue: item.unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: FoodUnit.values
                      .map((u) =>
                          DropdownMenuItem(value: u, child: Text(u.name)))
                      .toList(),
                  onChanged: (u) =>
                      setState(() => item.unit = u ?? item.unit),
                ),
              ),
            ],
          ),
          if (item.candidates.length > 1) ...[
            const SizedBox(height: 8),
            DropdownButton<int>(
              isExpanded: true,
              value: item.selectedIndex >= 0 ? item.selectedIndex : null,
              hint: const Text('Change match'),
              items: [
                for (var i = 0; i < item.candidates.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(
                      '${item.candidates[i].description}  ·  '
                      '${item.candidates[i].caloriesPer100g.round()} kcal/100g',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (i) => i == null ? null : _changeMatch(item, i),
            ),
          ],
          const SizedBox(height: 8),
          _pair(item.calCtl, 'Calories', 'kcal', item.proteinCtl, 'Protein',
              'g'),
          _pair(item.carbsCtl, 'Carbs', 'g', item.fatsCtl, 'Fats', 'g'),
          _pair(item.fiberCtl, 'Fiber', 'g', item.sugarCtl, 'Added sugar', 'g'),
          _pair(item.fruitCtl, 'Fruit', 'cups', item.veggieCtl, 'Veggies',
              'cups'),
        ],
      ),
    );
  }

  Widget _pair(
    TextEditingController a,
    String aLabel,
    String aUnit,
    TextEditingController b,
    String bLabel,
    String bUnit,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: _num(a, aLabel, aUnit)),
            const SizedBox(width: 8),
            Expanded(child: _num(b, bLabel, bUnit)),
          ],
        ),
      );

  Widget _num(TextEditingController c, String label, String unit) => TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) => setState(() {}),
      );
}
