import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'core/bootstrap.dart';
import 'data/sync/cloud_identity.dart';
import 'data/sync/reconciliation.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

Future<void> main() async {
  // bootstrap(): ensureInitialized + create DB + implicit User row (UUID v7).
  await bootstrap();

  // Slice 2 thin thread step 3: identity rewrite + outbox seed, BEFORE any
  // screen gets a userId (build decision A1). Local-only, no network; no-op
  // until a cloud identity exists from an earlier launch.
  await Reconciliation.runIfNeeded();

  // Resolve the single implicit user, then decide the landing screen once.
  // No targets row yet  -> onboarding;  row exists (even all-null) -> dashboard.
  final user = await db.userDao.getUser();
  final userId = user!.id;
  final targets = await db.perUserTargetsDao.getTargets(userId);

  runApp(CalorieApp(userId: userId, hasTargets: targets != null));

  // Slice 2 thin thread step 2: anonymous cloud identity, in the background.
  // Never awaited — launch and offline use never wait on the cloud (FSD §5.1).
  unawaited(CloudIdentity.ensureAnonymousSession());
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