import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/features/dashboard/dashboard_screen.dart';

// Atwater factors for the B1 %-to-grams derivation.
const double _kcalPerGramCarbs = 4;
const double _kcalPerGramFats = 9;

/// Stage 1 onboarding: a single flat form (not the branching questionnaire yet).
/// All fields optional — unanswered => not tracked (null). Enforces the
/// carbs%/fats% -> calorie-target gate (FSD §3.1) and derives frozen gram
/// limits once (B1, Architecture §1 Decision 10).
class OnboardingScreen extends StatefulWidget {
  final String userId;
  const OnboardingScreen({super.key, required this.userId});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _calorie = TextEditingController();
  final _protein = TextEditingController();
  final _fiber = TextEditingController();
  final _fruitCups = TextEditingController();
  final _veggieCups = TextEditingController();
  final _addedSugar = TextEditingController();
  final _carbsPct = TextEditingController();
  final _fatsPct = TextEditingController();

  String? _error;
  bool _saving = false;

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
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  int? _parseInt(TextEditingController c) {
    final s = c.text.trim();
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }

  double? _parseDouble(TextEditingController c) {
    final s = c.text.trim();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  Future<void> _save() async {
    final calorie = _parseInt(_calorie);
    final carbsPct = _parseDouble(_carbsPct);
    final fatsPct = _parseDouble(_fatsPct);

    // Conditional gate: a %-of-calories metric requires the calorie target.
    final usesPct = carbsPct != null || fatsPct != null;
    if (usesPct && calorie == null) {
      setState(() => _error =
          'Set a calorie target — carbs % and fats % are derived from it.');
      return;
    }

    // B1: derive the gram limit once from the calorie target, then freeze it.
    double? carbsLimitG;
    double? fatsLimitG;
    if (carbsPct != null && calorie != null) {
      carbsLimitG = calorie * (carbsPct / 100) / _kcalPerGramCarbs;
    }
    if (fatsPct != null && calorie != null) {
      fatsLimitG = calorie * (fatsPct / 100) / _kcalPerGramFats;
    }

    Value<T> val<T>(T? value) =>
        value == null ? const Value.absent() : Value(value);

    final companion = PerUserTargetsCompanion.insert(
      userId: widget.userId,
      calorieTarget:
          calorie == null ? const Value.absent() : Value(calorie),
      proteinTarget: val(_parseDouble(_protein)),
      fiberTarget: val(_parseDouble(_fiber)),
      fruitCupsTarget: val(_parseDouble(_fruitCups)),
      veggieCupsTarget: val(_parseDouble(_veggieCups)),
      addedSugarLimit: val(_parseDouble(_addedSugar)),
      carbsLimitG: carbsLimitG == null
          ? const Value.absent()
          : Value(carbsLimitG),
      fatsLimitG:
          fatsLimitG == null ? const Value.absent() : Value(fatsLimitG),
      // water_target / weight_target stay absent -> null (later slices).
    );

    setState(() {
      _saving = true;
      _error = null;
    });
    await db.perUserTargetsDao.saveTargets(companion);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set your targets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Fill in what you want to track. Anything left blank is simply not '
            'tracked — you can change it later in Settings.',
          ),
          const SizedBox(height: 16),
          _section('Dietary goal'),
          _field(_calorie, 'Calorie target', 'kcal/day'),
          _section('Fruits & veggies'),
          _field(_fruitCups, 'Fruit target', 'cups/day'),
          _field(_veggieCups, 'Veggie target', 'cups/day'),
          _section('Macros'),
          _field(_protein, 'Protein target', 'g/day'),
          _field(_carbsPct, 'Carbs limit', '% of calories'),
          _field(_fatsPct, 'Fats limit', '% of calories'),
          _section('Macro nutritional'),
          _field(_addedSugar, 'Added sugar limit', 'g/day'),
          _field(_fiber, 'Fiber target', 'g/day'),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Start logging'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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