import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

/// "Backup not syncing" escalation state (Slice 2 FSD §5.3, §3.4 item type 2;
/// Architecture §2.5.1 LG-2). App-local (FSD §6.7) — shared_preferences.
///
/// Stage 3 build decisions (2026-11-05):
/// - A *failed run* = a drain run that started and hit an error. Runs gated
///   off (offline / not reconciled) do NOT count.
/// - Counter resets when a run finishes with the queue empty.
/// - Auth/credential errors escalate immediately; everything else (network,
///   timeout, server, data) counts toward [escalationThreshold].
/// - Any successful run clears the escalation — including `auth` (a success
///   proves the credential works; re-link remains the user-facing fix).
///
/// Stage 5 (Needs-attention queue) reads [escalation], [lastError] and the
/// pending count; it does not write here.
enum SyncEscalation { none, transient, auth }

enum DrainFailureKind { auth, transient }

class SyncHealth {
  SyncHealth._();

  /// LG-2 threshold N (FSD §10 tunable, ~3–5). Tune in Phase 4.
  static const escalationThreshold = 5;

  static const _failuresKey = 'drain_consecutive_failures_v1';
  static const _escalationKey = 'drain_escalation_v1';
  static const _lastErrorKey = 'drain_last_error_v1';

  /// Live escalation state for the UI (Stage 5 badge / queue item).
  static final ValueNotifier<SyncEscalation> escalation =
      ValueNotifier(SyncEscalation.none);

  /// Load persisted state into [escalation]. Call once at startup.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    escalation.value = _parse(prefs.getString(_escalationKey));
  }

  static Future<int> consecutiveFailures() async =>
      (await SharedPreferences.getInstance()).getInt(_failuresKey) ?? 0;

  static Future<String?> lastError() async =>
      (await SharedPreferences.getInstance()).getString(_lastErrorKey);

  /// A run finished with the queue empty: reset everything.
  static Future<void> recordSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    final had = escalation.value;
    await prefs.setInt(_failuresKey, 0);
    await prefs.setString(_escalationKey, SyncEscalation.none.name);
    await prefs.remove(_lastErrorKey);
    escalation.value = SyncEscalation.none;
    if (had != SyncEscalation.none) {
      debugPrint('SyncHealth: escalation CLEARED (was ${had.name})');
    }
  }

  /// A run started and failed.
  static Future<void> recordFailure(DrainFailureKind kind, String error) async {
    final prefs = await SharedPreferences.getInstance();
    final failures = (prefs.getInt(_failuresKey) ?? 0) + 1;
    await prefs.setInt(_failuresKey, failures);
    await prefs.setString(_lastErrorKey, error);

    var next = escalation.value;
    if (kind == DrainFailureKind.auth) {
      next = SyncEscalation.auth; // trips immediately
    } else if (next == SyncEscalation.none &&
        failures >= escalationThreshold) {
      next = SyncEscalation.transient;
    } // an existing auth escalation is never downgraded by a transient error

    await prefs.setString(_escalationKey, next.name);
    if (next != escalation.value) {
      debugPrint('SyncHealth: ESCALATED -> ${next.name} '
          '(failures=$failures)');
    }
    escalation.value = next;
    debugPrint('SyncHealth: failure ${kind.name} '
        '($failures/$escalationThreshold), escalation=${next.name}');
  }

  static SyncEscalation _parse(String? s) => SyncEscalation.values
      .firstWhere((e) => e.name == s, orElse: () => SyncEscalation.none);
}
