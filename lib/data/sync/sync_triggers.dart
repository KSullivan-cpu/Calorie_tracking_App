import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/widgets.dart' show AppLifecycleListener;

import '../../core/bootstrap.dart' show cloudConfigured, db;
import 'cloud_identity.dart';
import 'drain.dart';

/// Hybrid drain triggers (Slice 2 FSD §5.3; Architecture §2.5.1).
///
/// Stage 3 build decisions (2026-11-05):
/// - Option C: backstop is an in-app timer that runs only while the app is
///   in the foreground. A true background job (WorkManager) is parked as an
///   additive later upgrade.
/// - Connectivity via connectivity_plus; mutation trigger debounced 5 s.
/// - Overlap is handled by Drain's in-memory running guard.
///
/// Every trigger: ensure a cloud session (also retries anonymous sign-in on
/// connectivity events, FSD §5.1) → Drain.run (which gates on reconciled +
/// online itself).
class SyncTriggers {
  SyncTriggers._();

  static const debounce = Duration(seconds: 5);
  static const backstop = Duration(minutes: 15);

  static Timer? _debounceTimer;
  static Timer? _backstopTimer;
  static StreamSubscription<List<ConnectivityResult>>? _connSub;
  static StreamSubscription<int>? _outboxSub;
  static AppLifecycleListener? _lifecycle;
  static bool _wasOnline = true;
  static bool _started = false;

  /// Call once, after runApp. Never throws, never blocks the UI.
  static Future<void> start() async {
    if (_started || !cloudConfigured) return;
    _started = true;

    _wasOnline = await Drain.isOnline();

    // Connectivity regained (offline -> online edge only).
    _connSub = Connectivity().onConnectivityChanged.listen((r) {
      final online = Drain.hasNetwork(r);
      if (online && !_wasOnline) _kick('connectivity');
      _wasOnline = online;
    });

    // App foreground / background. Backstop runs only while foregrounded.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        _kick('foreground');
        _startBackstop();
      },
      onPause: () {
        _stopBackstop();
        _kick('background');
      },
    );

    // Mutation (debounced): any outbox insert. Watching the outbox means the
    // DAOs (and Slice 3+ writers) need no trigger code — the §5.2 invariant
    // already guarantees every synced write lands here. Skip the initial
    // emission (that's current state, not a mutation).
    var first = true;
    _outboxSub = db
        .customSelect('SELECT COUNT(*) AS n FROM outbox_entries',
            readsFrom: {db.outboxEntries})
        .watchSingle()
        .map((row) => row.read<int>('n'))
        .listen((_) {
      if (first) {
        first = false;
        return;
      }
      _debounceTimer?.cancel();
      _debounceTimer = Timer(debounce, () => _kick('mutation'));
    });

    _startBackstop();
    _kick('launch');
    debugPrint('SyncTriggers: started');
  }

  /// Retry now (Stage 5 Needs-attention action) and other manual callers.
  static Future<void> runNow(String reason) => _kick(reason);

  static Future<void> _kick(String reason) async {
    try {
      await CloudIdentity.ensureAnonymousSession();
      await Drain.run(reason: reason);
    } catch (e) {
      debugPrint('SyncTriggers[$reason]: error $e');
    }
  }

  static void _startBackstop() {
    _backstopTimer?.cancel();
    _backstopTimer = Timer.periodic(backstop, (_) => _kick('backstop'));
  }

  static void _stopBackstop() {
    _backstopTimer?.cancel();
    _backstopTimer = null;
  }

  /// Not needed in normal app life; here for tests / completeness.
  static Future<void> stop() async {
    _stopBackstop();
    _debounceTimer?.cancel();
    await _connSub?.cancel();
    await _outboxSub?.cancel();
    _lifecycle?.dispose();
    _started = false;
  }
}
