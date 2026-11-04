import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/bootstrap.dart' show cloudConfigured;

/// Supabase anonymous identity (Architecture §2.3 LG-1; Slice 2 FSD §5.1).
///
/// Thin-thread scope: one background attempt per launch. Never blocks the UI
/// and never throws — offline or failure just logs and tries again next launch.
/// Connectivity-triggered retry arrives with the drain-trigger stage.
class CloudIdentity {
  CloudIdentity._();

  /// Returns the anonymous uid, or null if the cloud isn't reachable/configured.
  ///
  /// Reuses a persisted session when one exists, so the device keeps ONE
  /// identity across launches — required, because this uid becomes the
  /// app's user_id at reconciliation.
  static Future<String?> ensureAnonymousSession() async {
    if (!cloudConfigured) return null;

    final auth = Supabase.instance.client.auth;

    final existing = auth.currentUser;
    if (existing != null) {
      debugPrint('Cloud identity: reusing session ${existing.id} '
          '(anonymous=${existing.isAnonymous})');
      return existing.id;
    }

    try {
      final res = await auth.signInAnonymously();
      final uid = res.user?.id;
      debugPrint('Cloud identity: anonymous sign-in OK $uid');
      return uid;
    } catch (e) {
      debugPrint('Cloud identity: anonymous sign-in failed '
          '(will retry next launch): $e');
      return null;
    }
  }
}
