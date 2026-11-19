import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/features/library/saved_items_list.dart';
import 'package:calorie_tracking_app/features/settings/backup_section.dart';
import 'package:calorie_tracking_app/features/supplements/supplements_section.dart';

// Atwater factors for the B1 %-to-grams derivation (mirrors onboarding).
const double _kcalPerGramCarbs = 4;
const double _kcalPerGramFats = 9;

/// Stage 3 Settings (FSD §3.6): edit the food targets set in onboarding.
///
/// Carbs/fats are shown as **%** (back-computed from the frozen gram limits +
/// calorie target on load); saving re-derives the frozen grams (B1, Arch §1
/// Decision 10). Because the grams are frozen, a change to the calorie target
/// does not silently recompute them — it triggers a re-confirm dialog first
/// (Arch §1.7). The §3.1 conditional gate holds here too: the calorie target
/// cannot be cleared while a %-metric (carbs %/fats %) is still tracked.
///
/// Clearing a field un-tracks that metric: Settings writes explicit values
/// (including null) for every food column, unlike onboarding's absent-on-insert.
class SettingsScreen extends StatefulWidget {
  final String userId;

  /// Section to open expanded and scroll to (Slice 3 Stage 4 O5) — used by
  /// the quick-log empty-state links. Null = all collapsed (default).
  final String? expand;

  static const sectionWater = 'Water';
  static const sectionSupplements = 'Supplements';

  const SettingsScreen({super.key, required this.userId, this.expand});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _calorie = TextEditingController();
  final _protein = TextEditingController();
  final _fiber = TextEditingController();
  final _fruitCups = TextEditingController();
  final _veggieCups = TextEditingController();
  final _addedSugar = TextEditingController();
  final _carbsPct = TextEditingController();
  final _fatsPct = TextEditingController();
  final _water = TextEditingController(); // oz/day (Slice 3, MARD v1.0.3)

  int? _loadedCalorie; // to detect a calorie-target change on save
  bool _ready = false;
  final _expandKey = GlobalKey(); // on the section named by widget.expand
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final t = await db.perUserTargetsDao.getTargets(widget.userId);
    if (t != null) {
      _loadedCalorie = t.calorieTarget;
      if (t.calorieTarget != null) _calorie.text = '${t.calorieTarget}';
      if (t.proteinTarget != null) _protein.text = _fmt(t.proteinTarget!);
      if (t.fiberTarget != null) _fiber.text = _fmt(t.fiberTarget!);
      if (t.fruitCupsTarget != null) _fruitCups.text = _fmt(t.fruitCupsTarget!);
      if (t.veggieCupsTarget != null) {
        _veggieCups.text = _fmt(t.veggieCupsTarget!);
      }
      if (t.addedSugarLimit != null) _addedSugar.text = _fmt(t.addedSugarLimit!);
      if (t.waterTarget != null) _water.text = _fmt(t.waterTarget!);
      // Back-compute carbs/fats % from the frozen grams + calorie target.
      final cal = t.calorieTarget;
      if (t.carbsLimitG != null && cal != null && cal > 0) {
        _carbsPct.text = _fmt(t.carbsLimitG! * _kcalPerGramCarbs / cal * 100);
      }
      if (t.fatsLimitG != null && cal != null && cal > 0) {
        _fatsPct.text = _fmt(t.fatsLimitG! * _kcalPerGramFats / cal * 100);
      }
    }
    if (!mounted) return;
    setState(() => _ready = true);
    if (widget.expand != null) {
      // Scroll the pre-expanded section into view once it has laid out.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _expandKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx,
              duration: const Duration(milliseconds: 300));
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _calorie,
      _protein,
      _fiber,
      _fruitCups,
      _veggieCups,
      _addedSugar,
      _carbsPct,
      _fatsPct,
      _water,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  int? _pInt(TextEditingController c) {
    final s = c.text.trim();
    return s.isEmpty ? null : int.tryParse(s);
  }

  double? _pDbl(TextEditingController c) {
    final s = c.text.trim();
    return s.isEmpty ? null : double.tryParse(s);
  }

  Future<void> _save() async {
    final calorie = _pInt(_calorie);
    final carbsPct = _pDbl(_carbsPct);
    final fatsPct = _pDbl(_fatsPct);
    final water = _pDbl(_water);

    // Slice 3 FSD §3.2 (Review CG-1): water target > 0 when set.
    if (water != null && water <= 0) {
      setState(() => _error = 'Water target must be more than 0 oz. '
          'Clear the field to stop tracking water.');
      return;
    }

    // Conditional gate (FSD §3.1 / §3.6): a %-of-calories metric requires the
    // calorie target; you clear the % limits before you can clear calories.
    final usesPct = carbsPct != null || fatsPct != null;
    if (usesPct && calorie == null) {
      setState(() => _error =
          'Set a calorie target — carbs % and fats % are derived from it. '
          'To stop tracking calories, clear the carbs %/fats % limits first.');
      return;
    }

    // Calorie-target change re-confirm (Arch §1.7, B1): the frozen gram limits
    // are not silently recomputed. If calories changed and a %-metric is
    // tracked, confirm the resulting new gram limits before saving.
    final calorieChanged = calorie != _loadedCalorie;
    if (calorieChanged && usesPct && calorie != null) {
      final newCarbsG =
          carbsPct == null ? null : calorie * (carbsPct / 100) / _kcalPerGramCarbs;
      final newFatsG =
          fatsPct == null ? null : calorie * (fatsPct / 100) / _kcalPerGramFats;
      final confirmed = await _confirmRederive(
          calorie, carbsPct, newCarbsG, fatsPct, newFatsG);
      if (confirmed != true) return; // Cancel -> nothing saved
    }

    // Derive the frozen gram limits from the (confirmed) %s × calorie target.
    double? carbsLimitG;
    double? fatsLimitG;
    if (carbsPct != null && calorie != null) {
      carbsLimitG = calorie * (carbsPct / 100) / _kcalPerGramCarbs;
    }
    if (fatsPct != null && calorie != null) {
      fatsLimitG = calorie * (fatsPct / 100) / _kcalPerGramFats;
    }

    // Explicit values (incl. null) for every food column + water so clearing
    // a field un-tracks it. weight left absent -> untouched (Slice 4).
    final companion = PerUserTargetsCompanion(
      userId: Value(widget.userId),
      calorieTarget: Value(calorie),
      proteinTarget: Value(_pDbl(_protein)),
      fiberTarget: Value(_pDbl(_fiber)),
      fruitCupsTarget: Value(_pDbl(_fruitCups)),
      veggieCupsTarget: Value(_pDbl(_veggieCups)),
      addedSugarLimit: Value(_pDbl(_addedSugar)),
      carbsLimitG: Value(carbsLimitG),
      fatsLimitG: Value(fatsLimitG),
      waterTarget: Value(water),
    );

    setState(() {
      _saving = true;
      _error = null;
    });
    await db.perUserTargetsDao.saveTargets(companion);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<bool?> _confirmRederive(
    int calorie,
    double? carbsPct,
    double? carbsG,
    double? fatsPct,
    double? fatsG,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update derived limits?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calorie target is now $calorie kcal. Your percentage limits '
                'will be recalculated:'),
            const SizedBox(height: 12),
            if (carbsPct != null && carbsG != null)
              Text('•  Carbs ${_fmt(carbsPct)}%  →  ${_fmt(carbsG)} g'),
            if (fatsPct != null && fatsG != null)
              Text('•  Fats ${_fmt(fatsPct)}%  →  ${_fmt(fatsG)} g'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Edit your targets. Clearing a field stops tracking '
              'that metric.'),
          const SizedBox(height: 16),
          // Collapsible, collapsed by default (Slice 3 Stage 2 decision).
          // Save covers every field, open or closed (controllers live in State).
          _group('Dietary goal', [
            _field(_calorie, 'Calorie target', 'kcal/day'),
          ]),
          _group('Fruits & veggies', [
            _field(_fruitCups, 'Fruit target', 'cups/day'),
            _field(_veggieCups, 'Veggie target', 'cups/day'),
          ]),
          _group('Macros', [
            _field(_protein, 'Protein target', 'g/day'),
            _field(_carbsPct, 'Carbs limit', '% of calories'),
            _field(_fatsPct, 'Fats limit', '% of calories'),
          ]),
          _group('Macro nutritional', [
            _field(_addedSugar, 'Added sugar limit', 'g/day'),
            _field(_fiber, 'Fiber target', 'g/day'),
          ]),
          _group(SettingsScreen.sectionWater, [
            _field(_water, 'Water target', 'oz/day'),
          ]),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Save'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          // Slice 2 FSD §3.2/§3.5: saved-items list in delete mode.
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Saved items'),
            subtitle: const Text('View and delete items in your library'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                SavedItemsList.openManage(context, userId: widget.userId),
          ),
          const Divider(),
          // Slice 3 FSD §3.2: Supplements list (saves immediately, not via Save).
          _group(SettingsScreen.sectionSupplements,
              [SupplementsSection(userId: widget.userId)]),
          const Divider(),
          // Slice 2 FSD §3.5: Backup section (Stage 6a).
          BackupSection(userId: widget.userId),
        ],
      ),
    );
  }

  Widget _group(String title, List<Widget> children) => ExpansionTile(
        key: title == widget.expand ? _expandKey : null,
        initiallyExpanded: title == widget.expand,
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        collapsedShape: const Border(),
        children: children,
      );

  Widget _field(TextEditingController c, String label, String unit) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: label,
            suffixText: unit,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      );
}
