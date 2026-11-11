import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

/// Optional email-link status (Slice 2 FSD §3.5, §5.4). App-local (FSD §6.7)
/// — shared_preferences, mirroring [SyncHealth].
///
/// Stage 6a (2026-11-11): read-only surface. Status is always [none] until
/// the 6b magic-link flow writes `pending` / `linked`.
enum LinkState { none, pending, linked }

class LinkStatus {
  final LinkState state;
  final String? email;
  const LinkStatus(this.state, [this.email]);

  static const notLinked = LinkStatus(LinkState.none);
}

class BackupLink {
  BackupLink._();

  static const _stateKey = 'link_status_v1';
  static const _emailKey = 'link_email_v1';

  /// Live link status for Settings → Backup (and the 6c nudge).
  static final ValueNotifier<LinkStatus> status =
      ValueNotifier(LinkStatus.notLinked);

  /// Load persisted state into [status]. Call once at startup.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final state = LinkState.values.firstWhere(
      (s) => s.name == prefs.getString(_stateKey),
      orElse: () => LinkState.none,
    );
    status.value = LinkStatus(state, prefs.getString(_emailKey));
  }

  /// Persist a new status (used from 6b).
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
}
