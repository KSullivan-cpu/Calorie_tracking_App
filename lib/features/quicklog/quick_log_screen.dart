import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/daos/supplement_entry_dao.dart';
import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/features/settings/settings_screen.dart';
import 'package:calorie_tracking_app/features/supplements/supplement_status.dart';

/// Named tunable constants (Slice 3 FSD §3.1, §10).
/// Any single water amount above this asks for confirmation first (D4).
const double kLargeWaterOz = 100;

/// How long the confirmation (and its Undo) stays visible.
const Duration kUndoDuration = Duration(seconds: 6);

/// Quick-log screen (Slice 3 FSD §3.1). Water (Stage 1) + supplements
/// (Stage 3) + empty states linking to Settings (Stage 4).
///
/// Degraded loop (MARD §2.4): Add auto-commits; the user stays on the screen
/// and the total updates in place (D3). The confirmation carries Undo (D4).
class QuickLogScreen extends StatefulWidget {
  final String userId;
  const QuickLogScreen({super.key, required this.userId});

  @override
  State<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends State<QuickLogScreen> {
  final _amount = TextEditingController();
  bool _busy = false;
  String? _error;

  /// Ticked supplement ids (S3). Pruned to active rows on every list update
  /// (G5); cleared after Log.
  final Set<String> _ticked = {};
  bool _logging = false;

  // Supplement stream cached per day so tick rebuilds don't resubscribe.
  DateTime? _suppDay;
  Stream<List<SupplementCount>>? _suppStream;

  Stream<List<SupplementCount>> get _supplements {
    final day = _todayStart;
    if (_suppStream == null || _suppDay != day) {
      _suppDay = day;
      _suppStream =
          db.supplementEntryDao.watchDayCounts(widget.userId, day);
    }
    return _suppStream!;
  }

  DateTime get _todayStart {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day); // local midnight
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Future<void> _addWater() async {
    final oz = double.tryParse(_amount.text.trim());
    if (oz == null || oz <= 0) {
      setState(() => _error = 'Enter an amount in oz');
      return;
    }
    setState(() => _error = null);

    if (oz > kLargeWaterOz) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Large amount'),
          content: Text('Log ${_fmt(oz)} oz of water?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Log'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    setState(() => _busy = true);
    final id = await db.waterEntryDao.add(widget.userId, oz);
    if (!mounted) return;
    setState(() => _busy = false);
    _amount.clear();
    FocusScope.of(context).unfocus();
    _confirm('Logged ${_fmt(oz)} oz', () => db.waterEntryDao.undo([id]));
  }

  Future<void> _logSupplements(List<SupplementCount> rows) async {
    final picked =
        rows.where((r) => _ticked.contains(r.supplement.id)).toList();
    if (picked.isEmpty) return;
    setState(() => _logging = true);
    final ids = await db.supplementEntryDao
        .logBatch(widget.userId, picked.map((r) => r.supplement.id).toList());
    if (!mounted) return;
    setState(() {
      _logging = false;
      _ticked.clear();
    });
    final msg = picked.length == 1
        ? 'Logged ${picked.first.supplement.name}'
        : 'Logged ${picked.length} supplements';
    _confirm(msg, () => db.supplementEntryDao.undo(ids));
  }

  /// Shared confirmation + Undo (S4). Only the most recent action is
  /// undoable (G2): a new message replaces the previous one.
  void _confirm(String message, Future<void> Function() onUndo) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(message),
      duration: kUndoDuration,
      persist: false, // auto-dismiss even though it has an action
      action: SnackBarAction(label: 'Undo', onPressed: onUndo),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water & supplements')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _waterSection(context),
            _supplementsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _waterSection(BuildContext context) {
    return StreamBuilder<PerUserTarget?>(
      stream: db.perUserTargetsDao.watchTargets(widget.userId),
      builder: (context, tSnap) {
        final target = tSnap.data?.waterTarget;
        return StreamBuilder<double>(
          stream: db.waterEntryDao.watchDayTotal(widget.userId, _todayStart),
          builder: (context, wSnap) {
            final total = wSnap.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Water',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    Text(target != null
                        ? '${_fmt(total)} / ${_fmt(target)} oz'
                        : '${_fmt(total)} oz today'),
                  ],
                ),
                if (target != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: target > 0
                          ? (total / target).clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green.shade400),
                    ),
                  ),
                ] else
                  // Untracked (FSD §3.1, D8): still logs; link to Settings.
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                            userId: widget.userId,
                            expand: SettingsScreen.sectionWater),
                      ),
                    ),
                    child: const Text('Set a water target'),
                  ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _busy ? null : _addWater(),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          suffixText: 'oz',
                          errorText: _error,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _busy ? null : _addWater,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _supplementsSection(BuildContext context) {
    return StreamBuilder<List<SupplementCount>>(
      stream: _supplements,
      builder: (context, snap) {
        final rows = snap.data ?? const <SupplementCount>[];
        // G5: drop ticks for rows deleted / no longer active.
        final active = rows.map((r) => r.supplement.id).toSet();
        _ticked.removeWhere((id) => !active.contains(id));
        if (!snap.hasData) return const SizedBox.shrink();

        final muted = Theme.of(context).colorScheme.onSurfaceVariant;
        final n = _ticked.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Text('Supplements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            // Empty state (FSD §3.1, D8; Stage 4 O5): link to Settings with
            // the Supplements section open.
            if (rows.isEmpty) ...[
              Text('No supplements yet.', style: TextStyle(color: muted)),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                        userId: widget.userId,
                        expand: SettingsScreen.sectionSupplements),
                  ),
                ),
                child: const Text('Add supplements'),
              ),
            ],
            ...rows.map((r) {
              final s = r.supplement;
              final st = supplementStatus(s, r.count);
              final type =
                  s.type == SupplementType.dailyTarget ? 'Daily' : 'As needed';
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                value: _ticked.contains(s.id),
                // Done rows stay tickable (D5).
                onChanged: _logging
                    ? null
                    : (v) => setState(() =>
                        v == true ? _ticked.add(s.id) : _ticked.remove(s.id)),
                title: Text(s.name,
                    style: st.done ? TextStyle(color: muted) : null),
                subtitle: Text('$type · ${st.label}',
                    style: TextStyle(color: muted)),
              );
            }),
            if (rows.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: (n == 0 || _logging)
                      ? null
                      : () => _logSupplements(rows),
                  child: Text(n == 0 ? 'Log' : 'Log ($n)'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
