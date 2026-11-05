import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/daos/lookup_cache_dao.dart'
    show PortionValues;
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

  // --- Slice 2 Stage 4: saved -> cache -> FDC -> manual (FSD §4) ---------

  static const _gPerOz = 28.349523125;
  bool _isWeight(FoodUnit u) => u == FoodUnit.g || u == FoodUnit.oz;
  double _toGrams(double q, FoodUnit u) => u == FoodUnit.oz ? q * _gPerOz : q;

  /// Copy + scale a stored portion (saved item or cache row) onto [item]:
  /// total ÷ base qty × parsed qty (Architecture §1 Decision 8). No qty typed
  /// -> base portion. g<->oz converts; other unit differences fill at base
  /// with a "unit mismatch — adjust" flag (G4).
  void _fillFromStored(
    DraftItem item, {
    required double baseQty,
    required FoodUnit baseUnit,
    required PortionValues v,
    required ItemSource source,
  }) {
    final parsedQty = double.tryParse(item.qtyCtl.text.trim()) ?? 1;
    double factor = 1;
    item.unitMismatch = false;
    if (!item.hasQty || baseQty <= 0) {
      item.unit = baseUnit;
      item.qtyCtl.text = _fmt(baseQty);
    } else if (item.unit == baseUnit) {
      factor = parsedQty / baseQty;
    } else if (_isWeight(item.unit) && _isWeight(baseUnit)) {
      factor = _toGrams(parsedQty, item.unit) / _toGrams(baseQty, baseUnit);
    } else {
      item.unit = baseUnit;
      item.qtyCtl.text = _fmt(baseQty);
      item.unitMismatch = true;
    }
    final vals = [
      v.calories, v.proteinG, v.carbsG, v.fatsG,
      v.fiberG, v.addedSugarG, v.fruitCups, v.veggieCups,
    ];
    final ctls = item.valueCtls;
    for (var i = 0; i < ctls.length; i++) {
      ctls[i].text = _fmt(vals[i] * factor);
    }
    item.lastQty = double.tryParse(item.qtyCtl.text.trim()) ?? 1;
    item.source = source;
    item.candidates = const [];
    item.selectedIndex = -1;
    item.valuesEdited = false;
    final base = source == ItemSource.frequent
        ? 'Matched from frequent items — tap to check'
        : 'From your library';
    item.status =
        item.unitMismatch ? '$base · Unit mismatch — adjust' : base;
  }

  PortionValues _valuesOf(DraftItem i) => PortionValues(
        calories: _d(i.calCtl),
        proteinG: _d(i.proteinCtl),
        carbsG: _d(i.carbsCtl),
        fatsG: _d(i.fatsCtl),
        fiberG: _d(i.fiberCtl),
        addedSugarG: _d(i.sugarCtl),
        fruitCups: _d(i.fruitCtl),
        veggieCups: _d(i.veggieCtl),
      );

  /// Local tiers (saved, then cache). True if one resolved the item.
  Future<bool> _resolveLocal(DraftItem item, String name) async {
    final saved = await db.savedItemDao.findByName(widget.userId, name);
    if (saved != null) {
      item.cacheRow = null;
      _fillFromStored(item,
          baseQty: saved.quantity,
          baseUnit: saved.unit,
          v: PortionValues(
            calories: saved.calories,
            proteinG: saved.proteinG,
            carbsG: saved.carbsG,
            fatsG: saved.fatsG,
            fiberG: saved.fiberG,
            addedSugarG: saved.addedSugarG,
            fruitCups: saved.fruitCups,
            veggieCups: saved.veggieCups,
          ),
          source: ItemSource.saved);
      return true;
    }
    final cached = await db.lookupCacheDao.findByName(widget.userId, name);
    if (cached != null) {
      item.cacheRow = cached;
      _fillFromStored(item,
          baseQty: cached.quantity,
          baseUnit: cached.unit,
          v: PortionValues(
            calories: cached.calories,
            proteinG: cached.proteinG,
            carbsG: cached.carbsG,
            fatsG: cached.fatsG,
            fiberG: cached.fiberG,
            addedSugarG: cached.addedSugarG,
            fruitCups: cached.fruitCups,
            veggieCups: cached.veggieCups,
          ),
          source: ItemSource.frequent);
      return true;
    }
    return false;
  }

  // --- Stage 4d: Save to library (FSD §3.1, G5) -----------------------------

  /// Name dialog → duplicate check → "Replace?". Marks the card; nothing is
  /// written until commit. "No" on Replace returns to the name field.
  Future<void> _markSave(DraftItem item) async {
    var name = item.saveName ?? item.nameCtl.text.trim();
    while (true) {
      final entered = await _askSaveName(name);
      if (entered == null || entered.trim().isEmpty) return; // cancelled
      name = entered.trim();
      final existing =
          await db.savedItemDao.findByName(widget.userId, name);
      if (existing == null) {
        setState(() {
          item.saveToLibrary = true;
          item.saveName = name;
          item.replaces = null;
        });
        return;
      }
      if (await _askReplace(existing) == true) {
        setState(() {
          item.saveToLibrary = true;
          item.saveName = name;
          item.replaces = existing;
        });
        return;
      }
      // No -> back to the name field (rename or cancel)
    }
  }

  void _unmarkSave(DraftItem item) => setState(() {
        item.saveToLibrary = false;
        item.saveName = null;
        item.replaces = null;
      });

  // The dialog owns its controller (disposed when the dialog's State is torn
  // down, AFTER the exit animation) — disposing it right after showDialog
  // returned crashed the still-animating TextField.
  Future<String?> _askSaveName(String initial) => showDialog<String>(
        context: context,
        builder: (_) => _SaveNameDialog(initial: initial),
      );

  Future<bool?> _askReplace(SavedItem existing) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Replace?'),
          content: Text(
            'Your library already has "${existing.name}" '
            '(${_fmt(existing.quantity)} ${existing.unit.name} · '
            '${_fmt(existing.calories)} kcal). Replace it?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Replace'),
            ),
          ],
        ),
      );

  /// Parse-time resolve runs the full tier order. A user-initiated 🔍 re-search
  /// ([preserveOnFailure]) goes straight to FDC — it's an explicit "look this
  /// up online", e.g. to replace a Frequent match (FSD §4 "row exists").
  Future<void> _resolve(DraftItem item, {bool preserveOnFailure = false}) async {
    final name = item.nameCtl.text.trim();
    if (name.isEmpty) return;
    if (!preserveOnFailure && await _resolveLocal(item, name)) {
      if (mounted) setState(() {});
      return;
    }
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
    item.source = fill.macros != null ? ItemSource.fdc : ItemSource.manual;
    item.cacheRow = null;
    item.unitMismatch = false;
    item.valuesEdited = false;
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
      d.hasQty = p.hasQty;
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
    setState(() {
      _applyFill(item, fill);
      item.source = fill.macros != null ? ItemSource.fdc : ItemSource.manual;
      item.valuesEdited = false;
    });
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
    // One transaction: entries (+ outbox) and cache writes (FSD §4 "On
    // commit"; Stage 4 D4). Counts bump only here, never at lookup.
    await db.transaction(() async {
      await db.foodEntryDao.insertEntries(companions);
      for (final i in valid) {
        final name = i.nameCtl.text.trim();
        final qty = double.tryParse(i.qtyCtl.text.trim()) ?? 1;
        switch (i.source) {
          case ItemSource.fdc:
            final m = (i.selectedIndex >= 0 &&
                    i.selectedIndex < i.candidates.length)
                ? i.candidates[i.selectedIndex]
                : null;
            await db.lookupCacheDao.recordFdcCommit(
              userId: widget.userId,
              name: name,
              quantity: qty,
              unit: i.unit,
              values: _valuesOf(i),
              sourceRef: m?.sourceId == null ? null : 'fdc:${m!.sourceId}',
            );
          case ItemSource.frequent:
            if (i.cacheRow != null) {
              await db.lookupCacheDao.recordFrequentUse(
                i.cacheRow!,
                quantity: qty,
                unit: i.unit,
                editedValues: i.valuesEdited ? _valuesOf(i) : null,
              );
            }
          case ItemSource.saved:
          case ItemSource.manual:
            break; // not cached (G6)
        }

        // Save to library (FSD §3.1): as logged; Replace = soft-delete the
        // existing item + insert (G5). Re-checked here so a same-name save
        // earlier in this batch is replaced too. Each write enqueued.
        if (i.saveToLibrary) {
          final saveName = (i.saveName ?? name).trim();
          final existing =
              await db.savedItemDao.findByName(widget.userId, saveName);
          if (existing != null) await db.savedItemDao.softDelete(existing);
          final v = _valuesOf(i);
          await db.savedItemDao.insertItem(SavedItemsCompanion.insert(
            userId: widget.userId,
            name: saveName,
            quantity: qty,
            unit: i.unit,
            calories: Value(v.calories),
            proteinG: Value(v.proteinG),
            carbsG: Value(v.carbsG),
            fatsG: Value(v.fatsG),
            fiberG: Value(v.fiberG),
            addedSugarG: Value(v.addedSugarG),
            fruitCups: Value(v.fruitCups),
            veggieCups: Value(v.veggieCups),
          ));
        }
      }
    });
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
      if (item.status != 'Resolving…') item.source.label,
      '${item.qtyCtl.text.trim()} ${item.unit.name}',
      if (kcal.isNotEmpty && kcal != '0') '$kcal kcal',
      if (item.saveToLibrary) '→ library',
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
                  // keyed on unit so a saved/cache fill that changes the unit
                  // (no-qty base portion, G4 mismatch) re-renders the field
                  key: ValueKey('${identityHashCode(item)}-${item.unit.name}'),
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
          _pair(item, item.calCtl, 'Calories', 'kcal', item.proteinCtl,
              'Protein', 'g'),
          _pair(item, item.carbsCtl, 'Carbs', 'g', item.fatsCtl, 'Fats', 'g'),
          _pair(item, item.fiberCtl, 'Fiber', 'g', item.sugarCtl,
              'Added sugar', 'g'),
          _pair(item, item.fruitCtl, 'Fruit', 'cups', item.veggieCtl,
              'Veggies', 'cups'),
          // D5: an edited Frequent card offers one-tap promotion (never auto).
          if (item.source == ItemSource.frequent &&
              item.valuesEdited &&
              !item.saveToLibrary)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _markSave(item),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Save to library?'),
              ),
            ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Save to library'),
            subtitle: item.saveToLibrary
                ? Text('as "${item.saveName}"'
                    '${item.replaces != null ? ' · replaces existing' : ''}')
                : null,
            value: item.saveToLibrary,
            onChanged: (v) =>
                v == true ? _markSave(item) : _unmarkSave(item),
          ),
        ],
      ),
    );
  }

  Widget _pair(
    DraftItem item,
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
            Expanded(child: _num(item, a, aLabel, aUnit)),
            const SizedBox(width: 8),
            Expanded(child: _num(item, b, bLabel, bUnit)),
          ],
        ),
      );

  Widget _num(DraftItem item, TextEditingController c, String label,
          String unit) =>
      TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) => setState(() => item.valuesEdited = true),
      );
}

/// "Save to library" name dialog (Stage 4d). Owns its TextEditingController
/// so it lives exactly as long as the dialog, exit animation included.
class _SaveNameDialog extends StatefulWidget {
  final String initial;
  const _SaveNameDialog({required this.initial});

  @override
  State<_SaveNameDialog> createState() => _SaveNameDialogState();
}

class _SaveNameDialogState extends State<_SaveNameDialog> {
  late final _ctl = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save to library'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saves on commit with this card\'s quantity and values.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _ctl.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
