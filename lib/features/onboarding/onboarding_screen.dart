import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/sync/backup_link.dart'
    show BackupLink;
import 'package:calorie_tracking_app/data/sync/restore.dart';
import 'package:calorie_tracking_app/features/dashboard/dashboard_screen.dart';
import 'package:calorie_tracking_app/features/settings/link_email_flow.dart'
    show EmailDialog;
import 'package:calorie_tracking_app/features/supplements/supplement_dialog.dart';
import 'package:calorie_tracking_app/features/supplements/supplements_section.dart';

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
  final _water = TextEditingController(); // oz/day (Slice 3 FSD §3.3)

  /// Supplements Yes/No (Slice 3 FSD §3.3, Stage 4 O2). Null = unanswered.
  /// Once any supplement exists the answer is locked to Yes (O3).
  bool? _takesSupplements;

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
      _water,
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

    // Water (Slice 3 FSD §3.3, Stage 4 O4): blank = not tracked; anything
    // else must be a number > 0.
    final waterText = _water.text.trim();
    final water = _parseDouble(_water);
    if (waterText.isNotEmpty && (water == null || water <= 0)) {
      setState(() => _error = 'Water target must be a number more than 0 oz, '
          'or leave it blank to not track water.');
      return;
    }

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
      waterTarget: val(water),
      // weight_target stays absent -> null (Slice 4).
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
          _restoreEntry(),
          const SizedBox(height: 8),
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
          _section('Hydration'),
          _field(_water, 'Water target', 'oz/day'),
          _section('Supplements'),
          _supplements(),
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

  /// FSD §3.6 primary restore entry (Stage 7a): magic-link sign-in to the
  /// existing identity. Fire-and-continue — the prompt opens when tapped.
  Future<void> _startRestore() async {
    final email = await showDialog<String>(
      context: context,
      builder: (_) => const EmailDialog(
        title: 'Restore from a previous phone',
        message: 'Enter the email you linked on your old phone. We\'ll email '
            'a sign-in link — tap it on this phone to restore.',
      ),
    );
    if (email == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Sending link…')));
    final r = await Restore.start(email);
    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(switch (r) {
        RestoreStart.sent =>
          'Link sent to $email. Tap it on this phone to restore.',
        RestoreStart.noBackup => 'No backup found for $email.',
        RestoreStart.offline =>
          'You\'re offline. Restoring needs a connection.',
        RestoreStart.rateLimited => BackupLink.rateLimitMessage,
        RestoreStart.failed => 'Couldn\'t send the link. Try again.',
      })));
  }

  Widget _restoreEntry() => ValueListenableBuilder<String?>(
        valueListenable: Restore.pendingEmail,
        builder: (context, pending, _) => pending == null
            ? Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _startRestore,
                  icon: const Icon(Icons.restore),
                  label: const Text('Restoring from a previous phone?'),
                ),
              )
            : Card(
                child: ListTile(
                  leading: const Icon(Icons.mark_email_unread_outlined),
                  title: const Text('Waiting for your restore link'),
                  subtitle: Text('Sent to $pending — tap it on this phone.'),
                  trailing: TextButton(
                    onPressed: () => Restore.abort(),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
      );

  /// Supplements Yes/No (O2) + the shared Settings list (add / edit /
  /// delete). The dialog saves immediately (Stage 2), so once any supplement
  /// exists No is disabled (O3) — also covers onboarding left mid-way.
  Widget _supplements() => StreamBuilder<List<TrackedSupplement>>(
        stream: db.trackedSupplementDao.watchActive(widget.userId),
        builder: (context, snap) {
          final hasAny = (snap.data ?? const []).isNotEmpty;
          final yes = hasAny || _takesSupplements == true;
          final selected = yes
              ? {true}
              : (_takesSupplements == false ? {false} : <bool>{});
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you take supplements you want to track?'),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [
                  const ButtonSegment(value: true, label: Text('Yes')),
                  ButtonSegment(
                      value: false, label: const Text('No'), enabled: !hasAny),
                ],
                selected: selected,
                onSelectionChanged: (s) {
                  if (s.isEmpty) return; // tapping the selected one: keep it
                  final v = s.first;
                  setState(() => _takesSupplements = v);
                  if (v && !hasAny) {
                    showSupplementDialog(context, userId: widget.userId);
                  }
                },
              ),
              if (yes) ...[
                const SizedBox(height: 8),
                SupplementsSection(userId: widget.userId),
              ],
            ],
          );
        },
      );

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