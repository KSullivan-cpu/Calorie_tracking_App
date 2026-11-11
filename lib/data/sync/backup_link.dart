import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart'
    show ValueNotifier, debugPrint, kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured, db;
import 'drain.dart';
import 'reconciliation.dart';
import 'sync_triggers.dart';

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
///
/// Stage 6c decisions (2026-11-11):
/// - Nudge: shown while not linked and not dismissed; tap OR ✕ dismisses
///   permanently (`backup_nudge_dismissed_v1`); tap opens the link flow.
/// - Re-secure (auth escalation): linked → magic-link sign-in to the linked
///   email (`shouldCreateUser: false`) → same identity → drain → escalation
///   clears. Not linked → unrecoverable identity; explain, never mint a new one
///   (open thread).
/// - Identity guard: any sign-in whose uid ≠ the local user id is refused
///   (signed out) so data is never written under another identity.
enum LinkState { none, pending, linked }

class LinkStatus {
  final LinkState state;
  final String? email;
  const LinkStatus(this.state, [this.email]);

  static const notLinked = LinkStatus(LinkState.none);
}

enum LinkRequestResult { sent, existingBackup, offline, noSession, failed }

enum ReSecureResult { sent, notLinked, offline, failed }

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
  static const _nudgeKey = 'backup_nudge_dismissed_v1';

  /// Debug-only test hook (Stage 6c, criterion 11 nudge): run with
  /// `--dart-define=DEBUG_UNLINK=1` to treat this run as not linked (in
  /// memory only; prefs and the Supabase identity are untouched). Ignored in
  /// release builds.
  static const _debugUnlink =
      kDebugMode && String.fromEnvironment('DEBUG_UNLINK') == '1';

  /// Dashboard nudge dismissed (FSD §3.7; permanent).
  static final ValueNotifier<bool> nudgeDismissed = ValueNotifier(false);

  static Future<void> dismissNudge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_nudgeKey, true);
    nudgeDismissed.value = true;
    debugPrint('BackupLink: nudge dismissed');
  }

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
    nudgeDismissed.value = prefs.getBool(_nudgeKey) ?? false;
    if (_debugUnlink) {
      status.value = LinkStatus.notLinked;
      debugPrint('DEBUG_UNLINK: treating this run as not linked');
    }
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
      (s) => unawaited(_onAuth(s, auth)),
      onError: (Object e) => debugPrint('BackupLink: auth stream error: $e'),
    );
    unawaited(_syncFromUser(auth.currentUser));
    // Pending from an earlier run: the link may have been confirmed while the
    // app was closed (or on another device). Refresh once to pick that up.
    if (status.value.state == LinkState.pending) unawaited(_refreshPending());
  }

  static Future<void> _onAuth(AuthState s, GoTrueClient auth) async {
    final user = s.session?.user ?? auth.currentUser;
    // Pre-reconciliation the local id is still the temporary local uid (the
    // first anonymous sign-in is SUPPOSED to differ) — guard only after.
    if (s.event == AuthChangeEvent.signedIn &&
        user != null &&
        await Reconciliation.isReconciled()) {
      final local = await db.userDao.getUser();
      if (local != null && local.id != user.id) {
        // Never let backup write under a different identity.
        debugPrint('BackupLink: sign-in landed on ${user.id}, expected '
            '${local.id} — REFUSED (signed out)');
        await auth.signOut(scope: SignOutScope.local);
        return;
      }
      debugPrint('BackupLink: signed in as ${user.id} (matches local user)');
      unawaited(SyncTriggers.runNow('resecure'));
    }
    await _syncFromUser(user);
  }

  /// Re-secure backup (FSD §5.4 re-link reuse; LG-2 auth recovery).
  static Future<ReSecureResult> reSecure() async {
    final cur = status.value;
    final email = cur.email;
    if (cur.state != LinkState.linked || email == null) {
      return ReSecureResult.notLinked;
    }
    if (!cloudConfigured) return ReSecureResult.failed;
    if (!await Drain.isOnline()) return ReSecureResult.offline;
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
        emailRedirectTo: redirectUrl,
      );
      debugPrint('BackupLink: re-secure link sent to $email');
      return ReSecureResult.sent;
    } catch (e) {
      debugPrint('BackupLink: re-secure failed: $e');
      return ReSecureResult.failed;
    }
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
    if (_debugUnlink) return;
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
