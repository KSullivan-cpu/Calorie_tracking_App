import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'core/bootstrap.dart';
import 'data/sync/backup_link.dart';
import 'data/sync/reconciliation.dart';
import 'data/sync/sync_health.dart';
import 'data/sync/sync_triggers.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

Future<void> main() async {
  // bootstrap(): ensureInitialized + create DB + implicit User row (UUID v7).
  await bootstrap();

  // Slice 2 thin thread step 3: identity rewrite + outbox seed, BEFORE any
  // screen gets a userId (build decision A1). Local-only, no network; no-op
  // until a cloud identity exists from an earlier launch.
  await Reconciliation.runIfNeeded();
  // One-time: enqueue rows written after reconcile but before the §5.2
  // invariant existed (this emulator's gap). No-op everywhere else.
  await Reconciliation.catchUpIfNeeded();
  // LG-2 escalation state (app-local) for Stage 5's Needs-attention queue.
  await SyncHealth.load();
  // Optional email-link status (FSD §3.5/§6.7) for Settings → Backup.
  await BackupLink.load();

  // Resolve the single implicit user, then decide the landing screen once.
  // No targets row yet  -> onboarding;  row exists (even all-null) -> dashboard.
  final user = await db.userDao.getUser();
  final userId = user!.id;
  final targets = await db.perUserTargetsDao.getTargets(userId);

  runApp(CalorieApp(userId: userId, hasTargets: targets != null));

  // Stage 3: hybrid drain triggers (launch, mutation-debounced, connectivity
  // regained, foreground/background, 15-min foreground backstop). Each
  // trigger ensures the anonymous session, then drains. Never awaited —
  // launch and offline use never wait on the cloud (FSD §5.1).
  unawaited(SyncTriggers.start());
}

class CalorieApp extends StatelessWidget {
  final String userId;
  final bool hasTargets;

  const CalorieApp({
    super.key,
    required this.userId,
    required this.hasTargets,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Stage 1 routing: plain Navigator. Onboarding pushReplacement -> Dashboard
      // on save; Dashboard pushes Entry and gets popped back to. No router pkg yet.
      home: hasTargets
          ? DashboardScreen(userId: userId)
          : OnboardingScreen(userId: userId),
    );
  }
}