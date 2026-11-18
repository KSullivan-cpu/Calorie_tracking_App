import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/features/settings/settings_screen.dart';

/// Named tunable constants (Slice 3 FSD §3.1, §10).
/// Any single water amount above this asks for confirmation first (D4).
const double kLargeWaterOz = 100;

/// How long the confirmation (and its Undo) stays visible.
const Duration kUndoDuration = Duration(seconds: 6);

/// Quick-log screen (Slice 3 FSD §3.1). Stage 1: water section only;
/// the supplements section arrives in Stage 3, empty states in Stage 4.
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

    // Only the most recent action is undoable (G2): a new message replaces it.
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text('Logged ${_fmt(oz)} oz'),
      duration: kUndoDuration,
      persist: false, // auto-dismiss even though it has an action
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => db.waterEntryDao.undo([id]),
      ),
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
          children: [_waterSection(context)],
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
                        builder: (_) => SettingsScreen(userId: widget.userId),
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
}
