import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/sync/restore.dart';
import 'package:calorie_tracking_app/features/dashboard/dashboard_screen.dart';
import 'package:calorie_tracking_app/features/onboarding/onboarding_screen.dart';

/// Restore prompt (Slice 2 FSD §3.6, §5.5 steps 2–3, 5). Opened once the
/// restore sign-in has landed on the backup identity.
///
/// 7a: detect (counts) → prompt (replace-warning when local data exists) →
/// decline / no backup = switch back to this device's identity.
/// 7b: confirm → non-cancellable progress → full pull → fresh navigation.
/// A failed pull leaves the phone unchanged ("Try again" / "Cancel").
class RestoreScreen extends StatefulWidget {
  const RestoreScreen({super.key});

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

enum _Phase { checking, failed, none, found, restoring, restoreFailed }

class _RestoreScreenState extends State<RestoreScreen> {
  _Phase _phase = _Phase.checking;
  BackupCounts? _counts;
  bool _localData = false;
  bool _busy = false;
  String _step = '';

  @override
  void initState() {
    super.initState();
    Restore.screenOpen = true;
    _detect();
  }

  @override
  void dispose() {
    Restore.screenOpen = false;
    super.dispose();
  }

  Future<void> _detect() async {
    setState(() => _phase = _Phase.checking);
    final counts = await Restore.detect();
    final local = await Restore.hasLocalData();
    if (!mounted) return;
    setState(() {
      _counts = counts;
      _localData = local;
      _phase = counts == null
          ? _Phase.failed
          : (counts.hasData ? _Phase.found : _Phase.none);
    });
  }

  /// Decline / no backup / give up: switch back, then return to the app.
  Future<void> _leave() async {
    setState(() => _busy = true);
    final ok = await Restore.abort();
    if (!mounted) return;
    if (!ok) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Couldn\'t switch back — check your connection and '
              'try again.')));
      return;
    }
    await goHome(Navigator.of(context));
  }

  Future<void> _confirm() async {
    setState(() {
      _phase = _Phase.restoring;
      _step = '';
    });
    try {
      await Restore.run((t) {
        if (!mounted) return;
        setState(() => _step = t == 'saving'
            ? 'Saving to this phone…'
            : 'Downloading ${Restore.stepLabels[t] ?? t}…');
      });
    } catch (e) {
      debugPrint('Restore: FAILED (phone unchanged): $e');
      if (mounted) setState(() => _phase = _Phase.restoreFailed);
      return;
    }
    if (!mounted) return;
    await goHome(Navigator.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // leave only via a button, so state is always resolved
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restore backup'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: switch (_phase) {
            _Phase.checking => const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Checking for a backup…'),
                ]),
              ),
            _Phase.failed => _message(
                'Couldn\'t check for a backup. Check your connection.',
                primary: ('Try again', _detect),
              ),
            _Phase.none => _message(
                'No backup found for '
                '${Restore.pendingEmail.value ?? 'this email'}. '
                'Nothing on this phone was changed.',
              ),
            _Phase.found => _found(),
            _Phase.restoring => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  const Text('Restoring your backup…',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_step),
                  const SizedBox(height: 12),
                  const Text('Keep the app open.'),
                ]),
              ),
            _Phase.restoreFailed => _message(
                'Restore didn\'t finish — nothing on this phone was changed. '
                'Check your connection and try again.',
                primary: ('Try again', _confirm),
              ),
          },
        ),
      ),
    );
  }

  Widget _message(String text, {(String, VoidCallback)? primary}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(text),
          const SizedBox(height: 24),
          if (primary != null) ...[
            FilledButton(
                onPressed: _busy ? null : primary.$2,
                child: Text(primary.$1)),
            const SizedBox(height: 8),
          ],
          OutlinedButton(
            onPressed: _busy ? null : _leave,
            child: const Text('Back'),
          ),
        ],
      );

  Widget _found() {
    final c = _counts!;
    final lines = <String>[
      '${c.foodEntries} food entries',
      '${c.savedItems} saved items',
      c.targets > 0 ? 'Targets set' : 'No targets',
      if (c.water > 0) '${c.water} water entries',
      if (c.weight > 0) '${c.weight} weight entries',
      if (c.supplements > 0) '${c.supplements} supplements',
      if (c.supplementEntries > 0)
        '${c.supplementEntries} supplement entries',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Backup found for ${Restore.pendingEmail.value}:',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final l in lines) Text('• $l'),
        const SizedBox(height: 16),
        if (_localData)
          Text(
            'Restoring replaces this phone\'s data with the backup.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _busy ? null : _confirm,
          child: const Text('Restore'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _busy ? null : _leave,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Replace the whole stack with the landing screen for the current local
/// user (fresh read — never a stale captured id; A1 lesson).
Future<void> goHome(NavigatorState nav) async {
  final user = await db.userDao.getUser();
  final userId = user!.id;
  final targets = await db.perUserTargetsDao.getTargets(userId);
  nav.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => targets != null
          ? DashboardScreen(userId: userId)
          : OnboardingScreen(userId: userId),
    ),
    (_) => false,
  );
}
