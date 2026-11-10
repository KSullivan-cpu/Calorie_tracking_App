import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/lookup/fdc_provider.dart';
import 'package:calorie_tracking_app/data/lookup/food_match.dart';
import 'package:calorie_tracking_app/data/lookup/lookup_provider.dart';
import 'package:calorie_tracking_app/data/sync/drain.dart' show Drain;
import 'package:calorie_tracking_app/features/attention/needs_attention.dart'
    show verificationDaysLeft;
import 'package:calorie_tracking_app/features/entry/item_resolver.dart';
import 'package:calorie_tracking_app/features/entry/meal_time.dart';

/// Verification review (Slice 2 FSD §3.4, G8; Stage 5d).
///
/// Within the 7-day window: fresh lookup (when FDC is reachable) and/or manual
/// values, then Confirm -> `is_verified=true`, values saved, version bumped,
/// enqueued. Past the window: confirm-only — values stay as logged (MARD §3.4).
/// Confirming all-zero values shows the zero-value warning (LG-2), both cases.
///
/// Shares the entry card's lookup + sizing logic (`lookupCandidates`,
/// `fillForWithMeasures`, the A3 unreachable rule); the layout mirrors the
/// entry card's fields. Name, quantity, unit, meal and time are not editable
/// (verification changes values only).
class VerifyReviewScreen extends StatefulWidget {
  final FoodEntry entry;
  const VerifyReviewScreen({super.key, required this.entry});

  @override
  State<VerifyReviewScreen> createState() => _VerifyReviewScreenState();
}

class _VerifyReviewScreenState extends State<VerifyReviewScreen> {
  final LookupProvider _provider = FdcProvider();

  final _cal = TextEditingController();
  final _pro = TextEditingController();
  final _carb = TextEditingController();
  final _fat = TextEditingController();
  final _fib = TextEditingController();
  final _sug = TextEditingController();
  final _fruit = TextEditingController();
  final _veg = TextEditingController();

  List<FoodMatch> _candidates = const [];
  int _selected = -1;
  String? _status;
  bool _looking = false;
  bool _saving = false;

  late final int _daysLeft = verificationDaysLeft(widget.entry.entryTimestamp);
  bool get _canFill => _daysLeft > 0;

  List<TextEditingController> get _ctls =>
      [_cal, _pro, _carb, _fat, _fib, _sug, _fruit, _veg];

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    final vals = [
      e.calories, e.proteinG, e.carbsG, e.fatsG,
      e.fiberG, e.addedSugarG, e.fruitCups, e.veggieCups,
    ];
    for (var i = 0; i < _ctls.length; i++) {
      _ctls[i].text = vals[i] == 0 ? '' : _fmt(vals[i]);
    }
  }

  @override
  void dispose() {
    for (final c in _ctls) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  Future<void> _lookup() async {
    setState(() {
      _looking = true;
      _status = 'Looking up…';
    });
    final name = widget.entry.name;
    final outcome = await Drain.isOnline()
        ? await lookupCandidates(_provider, name)
        : const LookupOutcome.unreachable();
    if (!mounted) return;
    if (outcome.matches.isEmpty) {
      setState(() {
        _looking = false;
        _status = outcome.unreachable
            ? 'FDC unavailable — enter values manually or try later'
            : 'No match — enter values manually';
      });
      return;
    }
    _candidates = outcome.matches;
    await _applyMatch(0);
    if (mounted) setState(() => _looking = false);
  }

  Future<void> _applyMatch(int index) async {
    _selected = index;
    final e = widget.entry;
    final fill = await fillForWithMeasures(
      provider: _provider,
      produceRef: produce,
      produceEntry: produce.match(e.name),
      match: _candidates[index],
      qty: e.quantity,
      unit: e.unit,
    );
    if (!mounted) return;
    setState(() {
      final m = fill.macros;
      if (m != null) {
        _cal.text = _fmt(m.calories);
        _pro.text = _fmt(m.proteinG);
        _carb.text = _fmt(m.carbsG);
        _fat.text = _fmt(m.fatsG);
        _fib.text = _fmt(m.fiberG);
        _sug.text = _fmt(m.addedSugarG);
      }
      if (fill.fruitCups != null) _fruit.text = _fmt(fill.fruitCups!);
      if (fill.veggieCups != null) _veg.text = _fmt(fill.veggieCups!);
      _status = fill.status;
    });
  }

  Future<void> _confirm() async {
    final e = widget.entry;
    final values = _canFill
        ? _ctls.map(_d).toList()
        : [
            e.calories, e.proteinG, e.carbsG, e.fatsG,
            e.fiberG, e.addedSugarG, e.fruitCups, e.veggieCups,
          ];
    if (values.every((v) => v == 0)) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No nutrition values'),
          content: const Text(
              'This item has no nutrition values. Confirming records it as zero.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Confirm')),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _saving = true);
    await db.foodEntryDao.verify(
      e,
      values: _canFill
          ? FoodEntriesCompanion(
              calories: Value(values[0]),
              proteinG: Value(values[1]),
              carbsG: Value(values[2]),
              fatsG: Value(values[3]),
              fiberG: Value(values[4]),
              addedSugarG: Value(values[5]),
              fruitCups: Value(values[6]),
              veggieCups: Value(values[7]),
            )
          : null, // past window: confirm-only, values unchanged (G8)
    );
    debugPrint('Verify "${e.name}": confirmed '
        '(${_canFill ? 'values filled' : 'confirm-only'}, '
        'v${e.version}->${e.version + 1})');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${e.name}" verified')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final t = e.entryTimestamp.toLocal();
    final when = '${t.month}/${t.day} · ${mealTypeLabel(e.mealType)}';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review entry')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(e.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${_fmt(e.quantity)} ${e.unit.name} · $when',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            _canFill
                ? '$_daysLeft day${_daysLeft == 1 ? '' : 's'} left to fill '
                    'values. Look it up or enter them, then confirm.'
                : 'Past the 7-day window — confirm only. Values stay as '
                    'logged.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (_canFill)
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _looking ? null : _lookup,
                  icon: _looking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.search),
                  label: const Text('Look up'),
                ),
                const SizedBox(width: 12),
                if (_status != null)
                  Expanded(
                    child: Text(_status!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
              ],
            ),
          if (_canFill && _candidates.length > 1) ...[
            const SizedBox(height: 8),
            DropdownButton<int>(
              isExpanded: true,
              value: _selected >= 0 ? _selected : null,
              hint: const Text('Change match'),
              items: [
                for (var i = 0; i < _candidates.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(
                      '${_candidates[i].description}  ·  '
                      '${_candidates[i].caloriesPer100g.round()} kcal/100g',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (i) => i == null ? null : _applyMatch(i),
            ),
          ],
          const SizedBox(height: 8),
          _pair(_cal, 'Calories', 'kcal', _pro, 'Protein', 'g'),
          _pair(_carb, 'Carbs', 'g', _fat, 'Fats', 'g'),
          _pair(_fib, 'Fiber', 'g', _sug, 'Added sugar', 'g'),
          _pair(_fruit, 'Fruit', 'cups', _veg, 'Veggies', 'cups'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _confirm,
            child: Text(_saving ? 'Confirming…' : 'Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _pair(TextEditingController a, String aLabel, String aUnit,
          TextEditingController b, String bLabel, String bUnit) =>
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
        enabled: _canFill,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      );
}
