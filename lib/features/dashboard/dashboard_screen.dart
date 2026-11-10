import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/features/attention/needs_attention.dart';
import 'package:calorie_tracking_app/features/dashboard/day_totals.dart';
import 'package:calorie_tracking_app/features/dashboard/metric_bar.dart';
import 'package:calorie_tracking_app/features/dashboard/unverified_note.dart';
import 'package:calorie_tracking_app/features/entry/entry_screen.dart';
import 'package:calorie_tracking_app/features/settings/settings_screen.dart';

/// Stage 2d dashboard = the "today" view (MARD §1.4). Committed 8-metric totals
/// vs targets, rendered with the shared dual-semantic bars, grouped build-up vs
/// stay-under. Live via watchEntriesForDay.
class DashboardScreen extends StatelessWidget {
  final String userId;
  const DashboardScreen({super.key, required this.userId});

  DateTime get _todayStart {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day); // local midnight (MARD §1.8)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          NeedsAttentionBadge(userId: userId),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(userId: userId),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EntryScreen(userId: userId)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Log food'),
      ),
      body: StreamBuilder<PerUserTarget?>(
        stream: db.perUserTargetsDao.watchTargets(userId),
        builder: (context, targetSnap) {
          final targets = targetSnap.data;
          return StreamBuilder<List<FoodEntry>>(
            stream: db.foodEntryDao.watchEntriesForDay(userId, _todayStart),
            builder: (context, entrySnap) {
              if (!entrySnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = buildMetricRows(entrySnap.data!, targets);
              if (rows.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No metrics tracked yet. Set targets in onboarding to see '
                      'your daily totals here.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              final nUnverified =
                  entrySnap.data!.where((e) => !e.isVerified).length;
              final buildUp =
                  rows.where((r) => r.kind == MetricKind.buildUp).toList();
              final stayUnder =
                  rows.where((r) => r.kind == MetricKind.stayUnder).toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  if (nUnverified > 0) ...[
                    UnverifiedNote(count: nUnverified),
                    const SizedBox(height: 12),
                  ],
                  if (buildUp.isNotEmpty) ...[
                    _header('Build up to'),
                    ...buildUp.map(MetricBar.new),
                  ],
                  if (stayUnder.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _header('Stay under'),
                    ...stayUnder.map(MetricBar.new),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _header(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );
}
