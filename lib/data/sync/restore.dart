import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:flutter/widgets.dart' show GlobalKey, NavigatorState;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured, db;
import 'backup_link.dart' show BackupLink;
import 'drain.dart';
import 'sync_triggers.dart';

/// Restore (Slice 2 FSD §3.6, §5.5) — Stage 7a: intent, sign-in, detection.
///
/// Build decisions (2026-11-14):
/// - **Restore intent flag (A):** `restore_pending_v1` = the email being
///   restored. While set, the same-identity guard allows a sign-in to the
///   OTHER identity — only when its email matches. Persisted, because the
///   link may be tapped after an app restart.
/// - **Session stash:** this device's own session (refresh token + uid) is
///   saved before the link is sent and kept current on every token refresh
///   (Supabase rotates refresh tokens; a stale one can revoke the session).
///   Decline / "no backup found" restores it. No stash (no session yet) →
///   decline just signs out; pre-reconcile the next trigger mints a fresh
///   anonymous identity (FSD §5.5 step 5).
/// - While pending: drain gated, reconciliation skipped, link status untouched.
/// - **Detection (C):** count the identity's active rows per synced table;
///   "has a backup" = any row besides `users`. Counts are shown in the prompt.
class Restore {
  Restore._();

  static const _pendingKey = 'restore_pending_v1';
  static const _stashTokenKey = 'restore_stash_token_v1';
  static const _stashUidKey = 'restore_stash_uid_v1';

  /// Email being restored, or null. Live for the onboarding banner.
  static final ValueNotifier<String?> pendingEmail = ValueNotifier(null);

  static String? _stashUid;

  /// Global navigator so a tapped link can open the restore screen from
  /// wherever the app is. Set on MaterialApp.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Restore screen opener, registered by main.dart (keeps this file UI-free).
  static void Function()? openScreen;
  static bool screenOpen = false;

  static bool get pending => pendingEmail.value != null;

  /// Load persisted state. Call at startup BEFORE reconciliation.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    pendingEmail.value = prefs.getString(_pendingKey);
    _stashUid = prefs.getString(_stashUidKey);
    if (pending) {
      debugPrint('Restore: pending for ${pendingEmail.value} '
          '(stash uid $_stashUid, landed=$landed)');
    }
  }

  /// The restore sign-in has landed: the session is the backup identity.
  static bool get landed {
    if (!pending || !cloudConfigured) return false;
    final u = Supabase.instance.client.auth.currentUser;
    if (u == null || u.id == _stashUid) return false;
    return (u.email ?? '').toLowerCase() == pendingEmail.value!.toLowerCase();
  }

  /// Send the restore sign-in link (existing identities only).
  static Future<RestoreStart> start(String email) async {
    if (!cloudConfigured) return RestoreStart.failed;
    if (!await Drain.isOnline()) return RestoreStart.offline;
    final auth = Supabase.instance.client.auth;
    final prefs = await SharedPreferences.getInstance();

    // Intent + stash first, so the landing sign-in is recognised even if the
    // app restarts before the link is tapped.
    await prefs.setString(_pendingKey, email);
    pendingEmail.value = email;
    await _stash(auth.currentSession);

    try {
      await auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
        emailRedirectTo: BackupLink.redirectUrl,
      );
      debugPrint('Restore: sign-in link sent to $email');
      return RestoreStart.sent;
    } on AuthException catch (e) {
      debugPrint('Restore: link request failed '
          '(code=${e.code}, status=${e.statusCode}): ${e.message}');
      await _clear();
      return _isNoAccount(e) ? RestoreStart.noBackup : RestoreStart.failed;
    } catch (e) {
      debugPrint('Restore: link request failed: $e');
      await _clear();
      return RestoreStart.failed;
    }
  }

  static bool _isNoAccount(AuthException e) =>
      const {'otp_disabled', 'user_not_found', 'signup_disabled'}
          .contains(e.code) ||
      e.message.toLowerCase().contains('signups not allowed');

  /// Called first by the auth listener. Returns true when the event belongs
  /// to the restore flow (caller then skips its own linking/guard logic).
  static Future<bool> handleAuth(AuthState s) async {
    if (!pending) return false;
    final user = s.session?.user;
    if (user == null) return false;

    final isBackup = user.id != _stashUid &&
        (user.email ?? '').toLowerCase() ==
            pendingEmail.value!.toLowerCase();

    if (isBackup) {
      if (s.event == AuthChangeEvent.signedIn) {
        debugPrint('Restore: sign-in landed on backup identity ${user.id}');
        _open();
      }
      return true; // never link/guard against the backup identity
    }

    // This device's own identity refreshed (or was first minted): keep the
    // stash current so a decline can switch back.
    if (s.event == AuthChangeEvent.tokenRefreshed ||
        s.event == AuthChangeEvent.signedIn) {
      if (_stashUid == null || user.id == _stashUid) {
        await _stash(s.session);
      }
    }
    return false;
  }

  /// Open the restore screen if the sign-in already landed (launch check).
  static void openIfLanded() {
    if (landed) _open();
  }

  static void _open() {
    if (screenOpen) return;
    openScreen?.call();
  }

  /// Cloud data for the backup identity (active rows), or null on failure.
  static Future<BackupCounts?> detect() async {
    try {
      final client = Supabase.instance.client;
      final uid = client.auth.currentUser!.id;
      Future<int> n(String t) => client
          .from(t)
          .count(CountOption.exact)
          .eq('user_id', uid)
          .isFilter('deleted_at', null);
      final c = BackupCounts(
        foodEntries: await n('food_entries'),
        savedItems: await n('saved_items'),
        targets: await n('per_user_targets'),
        water: await n('water_entries'),
        weight: await n('weight_entries'),
        supplements: await n('tracked_supplements'),
        supplementEntries: await n('supplement_entries'),
      );
      debugPrint('Restore: detected $c');
      return c;
    } catch (e) {
      debugPrint('Restore: detect failed: $e');
      return null;
    }
  }

  /// Does this phone hold data that a restore would replace?
  static Future<bool> hasLocalData() async {
    final r = await db.customSelect(
      'SELECT (SELECT COUNT(*) FROM food_entries) + '
      '(SELECT COUNT(*) FROM saved_items) + '
      '(SELECT COUNT(*) FROM per_user_targets) AS n',
    ).getSingle();
    return r.read<int>('n') > 0;
  }

  /// Decline / no backup: switch back to this device's identity and clear the
  /// restore state. Returns false if switching back failed (stays pending).
  static Future<bool> abort() async {
    final auth = Supabase.instance.client.auth;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_stashTokenKey);
    final switched = auth.currentUser != null && auth.currentUser!.id != _stashUid;
    try {
      if (switched) {
        if (token != null) {
          await auth.setSession(token);
          debugPrint('Restore: switched back to ${auth.currentUser?.id}');
        } else {
          await auth.signOut(scope: SignOutScope.local);
          debugPrint('Restore: no stashed session — signed out');
        }
      }
    } catch (e) {
      debugPrint('Restore: switch back failed (still pending): $e');
      return false;
    }
    await _clear();
    debugPrint('Restore: aborted');
    unawaited(SyncTriggers.runNow('restore-abort'));
    return true;
  }

  static Future<void> _stash(Session? s) async {
    final prefs = await SharedPreferences.getInstance();
    final token = s?.refreshToken;
    if (s == null || token == null) {
      await prefs.remove(_stashTokenKey);
      await prefs.remove(_stashUidKey);
      _stashUid = null;
      return;
    }
    await prefs.setString(_stashTokenKey, token);
    await prefs.setString(_stashUidKey, s.user.id);
    _stashUid = s.user.id;
  }

  /// Clear all restore state (also used by 7b after a successful pull).
  static Future<void> clearState() => _clear();

  static Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingKey);
    await prefs.remove(_stashTokenKey);
    await prefs.remove(_stashUidKey);
    _stashUid = null;
    pendingEmail.value = null;
  }
}

enum RestoreStart { sent, noBackup, offline, failed }

class BackupCounts {
  final int foodEntries, savedItems, targets, water, weight, supplements,
      supplementEntries;
  const BackupCounts({
    required this.foodEntries,
    required this.savedItems,
    required this.targets,
    required this.water,
    required this.weight,
    required this.supplements,
    required this.supplementEntries,
  });

  /// "Has a backup" = any synced row besides `users` (Option C).
  bool get hasData =>
      foodEntries + savedItems + targets + water + weight + supplements +
          supplementEntries >
      0;

  @override
  String toString() => 'food=$foodEntries saved=$savedItems '
      'targets=$targets water=$water weight=$weight '
      'supplements=$supplements supplementEntries=$supplementEntries';
}
