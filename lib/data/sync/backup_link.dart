import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured;
import 'drain.dart';

/// Optional email-link status (Slice 2 FSD §3.5, §5.4). App-local (FSD §6.7)
/// — shared_preferences, mirroring [SyncHealth].
///
/// Stage 6b decisions (2026-11-11):
/// - Link = `updateUser(email)` on the current anonymous identity (same uid,
///   so every backed-up row stays attached). Supabase sends its "confirm
///   email change" mail; tapping it makes the identity permanent.
/// - Deep link scheme (Option A): [redirectUrl]. Must match the Android
///   intent-filter AND Supabase → Auth → Redirect URLs.
/// - Fire-and-continue: request → *pending*; confirmation arrives via the
///   deep link (supabase_flutter exchanges it) → auth-state listener → *linked*.
/// - "Email taken" (`email_exists`) is treated as "this email has an existing
///   backup" (CG-2) → restore-or-cancel prompt. Stage 7 confirms data exists.
enum LinkState { none, pending, linked }

class LinkStatus {
  final LinkState state;
  final String? email;
  const LinkStatus(this.state, [this.email]);

  static const notLinked = LinkStatus(LinkState.none);
}

enum LinkRequestResult { sent, existingBackup, offline, noSession, failed }

class LinkRequestOutcome {
  final LinkRequestResult result;
  final String? error;
  const LinkRequestOutcome(this.result, [this.error]);
}

class BackupLink {
  BackupLink._();

  static const redirectUrl = 'com.kjs.calorietracker://login-callback';

  static const _stateKey = 'link_status_v1';
  static const _emailKey = 'link_email_v1';

  /// Live link status for Settings → Backup (and the 6c nudge).
  static final ValueNotifier<LinkStatus> status =
      ValueNotifier(LinkStatus.notLinked);

  static StreamSubscription<AuthState>? _authSub;

  /// Load persisted state into [status]. Call once at startup.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final state = LinkState.values.firstWhere(
      (s) => s.name == prefs.getString(_stateKey),
      orElse: () => LinkState.none,
    );
    status.value = LinkStatus(state, prefs.getString(_emailKey));
  }

  /// Persist a new status.
  static Future<void> set(LinkState state, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateKey, state.name);
    if (email == null) {
      await prefs.remove(_emailKey);
    } else {
      await prefs.setString(_emailKey, email);
    }
    status.value = LinkStatus(state, email);
    debugPrint('BackupLink: ${state.name}${email == null ? '' : ' ($email)'}');
  }

  /// Watch auth state so a tapped magic link (handled by supabase_flutter's
  /// deep-link listener) flips *pending* → *linked*. Call once at startup,
  /// after [load]. Never blocks launch.
  static void startListening() {
    if (!cloudConfigured || _authSub != null) return;
    final auth = Supabase.instance.client.auth;
    _authSub = auth.onAuthStateChange.listen(
      (s) => unawaited(_syncFromUser(s.session?.user ?? auth.currentUser)),
      onError: (Object e) => debugPrint('BackupLink: auth stream error: $e'),
    );
    unawaited(_syncFromUser(auth.currentUser));
    // Pending from an earlier run: the link may have been confirmed while the
    // app was closed (or on another device). Refresh once to pick that up.
    if (status.value.state == LinkState.pending) unawaited(_refreshPending());
  }

  static Future<void> _refreshPending() async {
    try {
      if (!await Drain.isOnline()) return;
      final auth = Supabase.instance.client.auth;
      if (auth.currentSession == null) return;
      await auth.refreshSession(); // emits tokenRefreshed -> _syncFromUser
    } catch (e) {
      debugPrint('BackupLink: pending refresh failed: $e');
    }
  }

  static Future<void> _syncFromUser(User? u) async {
    final email = u?.email;
    if (u == null || email == null || email.isEmpty) return;
    if (u.emailConfirmedAt == null) return;
    final cur = status.value;
    if (cur.state == LinkState.linked && cur.email == email) return;
    await set(LinkState.linked, email: email);
  }

  /// Ask Supabase to send the link. Fire-and-continue: returns as soon as the
  /// request is accepted; confirmation happens whenever the user taps it.
  static Future<LinkRequestOutcome> requestLink(String email) async {
    if (!cloudConfigured) {
      return const LinkRequestOutcome(
          LinkRequestResult.failed, 'Cloud backup is not configured.');
    }
    if (!await Drain.isOnline()) {
      return const LinkRequestOutcome(LinkRequestResult.offline);
    }
    final auth = Supabase.instance.client.auth;
    if (auth.currentUser == null) {
      // Session lost (auth escalation) — Re-secure path, Stage 6c.
      return const LinkRequestOutcome(LinkRequestResult.noSession);
    }
    try {
      await auth.updateUser(
        UserAttributes(email: email),
        emailRedirectTo: redirectUrl,
      );
      await set(LinkState.pending, email: email);
      debugPrint('BackupLink: link requested for $email');
      return const LinkRequestOutcome(LinkRequestResult.sent);
    } on AuthException catch (e) {
      debugPrint('BackupLink: request failed '
          '(code=${e.code}, status=${e.statusCode}): ${e.message}');
      if (_isEmailTaken(e)) {
        return const LinkRequestOutcome(LinkRequestResult.existingBackup);
      }
      return LinkRequestOutcome(LinkRequestResult.failed, e.message);
    } catch (e) {
      debugPrint('BackupLink: request failed: $e');
      return LinkRequestOutcome(LinkRequestResult.failed, '$e');
    }
  }

  static bool _isEmailTaken(AuthException e) =>
      e.code == 'email_exists' ||
      e.message.toLowerCase().contains('already been registered');
}
