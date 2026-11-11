import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/sync/drain.dart' show Drain;
import 'package:calorie_tracking_app/data/sync/sync_health.dart';
import 'package:calorie_tracking_app/data/sync/sync_triggers.dart';
import 'package:calorie_tracking_app/features/attention/verify_review_screen.dart';
import 'package:calorie_tracking_app/features/entry/meal_time.dart';

/// Needs-attention queue (Slice 2 FSD §3.4, G1). Pull-only: never opens itself,
/// never notifies (MARD §1.7). Entry points: dashboard badge (here) and a
/// Settings link (Stage 6).
///
/// Stage 5c decisions (2026-11-09): backup item pinned on top; unverified
/// entries oldest first with a days-left hint; tap -> full-screen review
/// (Stage 5d); badge = app-bar icon with count, shown only when non-empty.

/// Verification window (G8; MARD "last 7 days editable"): today + the 6 prior
/// local days. Returns days left to fill values (1 = last day), or 0 when the
/// entry is past the window (confirm-only).
///
/// Debug-only `--dart-define=VERIFY_AGE_SHIFT=N` ages every entry by N days so
/// the past-window (confirm-only) path is testable without waiting a week.
const _ageShift = int.fromEnvironment('VERIFY_AGE_SHIFT');

int verificationDaysLeft(DateTime entryTimestamp, {DateTime? now}) {
  final n = (now ?? DateTime.now()).add(Duration(days: _ageShift));
  final today = DateTime(n.year, n.month, n.day);
  final t = entryTimestamp.toLocal();
  final entryDay = DateTime(t.year, t.month, t.day);
  final daysAgo = today.difference(entryDay).inDays;
  final left = 7 - daysAgo;
  return left < 0 ? 0 : left;
}

/// Queue item count = unverified entries + 1 if backup is escalated.
/// Stateful so the DB watch is created once, not on every rebuild.
class _QueueCount extends StatefulWidget {
  final String userId;
  final Widget Function(BuildContext, int count, List<FoodEntry> unverified,
      SyncEscalation esc) builder;
  const _QueueCount({required this.userId, required this.builder});

  @override
  State<_QueueCount> createState() => _QueueCountState();
}

class _QueueCountState extends State<_QueueCount> {
  late final Stream<List<FoodEntry>> _unverified =
      db.foodEntryDao.watchUnverified(widget.userId);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<SyncEscalation>(
        valueListenable: SyncHealth.escalation,
        builder: (context, esc, _) => StreamBuilder<List<FoodEntry>>(
          stream: _unverified,
          builder: (context, snap) {
            final unverified = snap.data ?? const <FoodEntry>[];
            final count =
                unverified.length + (esc == SyncEscalation.none ? 0 : 1);
            return widget.builder(context, count, unverified, esc);
          },
        ),
      );
}

/// Dashboard app-bar badge (FSD §3.7). Hidden when the queue is empty.
class NeedsAttentionBadge extends StatelessWidget {
  final String userId;
  const NeedsAttentionBadge({super.key, required this.userId});

  @override
  Widget build(BuildContext context) => _QueueCount(
        userId: userId,
        builder: (context, count, _, __) {
          if (count == 0) return const SizedBox.shrink();
          return IconButton(
            tooltip: 'Needs attention',
            icon: Badge.count(
              count: count,
              child: const Icon(Icons.notifications_none),
            ),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => NeedsAttentionScreen(userId: userId),
            )),
          );
        },
      );
}

/// Settings → Backup link to the queue (FSD §3.5). Always shown; carries the
/// count when the queue is non-empty (Stage 6a).
class NeedsAttentionLink extends StatelessWidget {
  final String userId;
  const NeedsAttentionLink({super.key, required this.userId});

  @override
  Widget build(BuildContext context) => _QueueCount(
        userId: userId,
        builder: (context, count, _, __) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: count == 0
              ? const Icon(Icons.notifications_none)
              : Badge.count(
                  count: count,
                  child: const Icon(Icons.notifications_none),
                ),
          title: const Text('Needs attention'),
          subtitle: Text(count == 0
              ? 'Nothing needs attention'
              : '$count ${count == 1 ? 'item' : 'items'}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => NeedsAttentionScreen(userId: userId),
          )),
        ),
      );
}

class NeedsAttentionScreen extends StatelessWidget {
  final String userId;
  const NeedsAttentionScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Needs attention')),
      body: _QueueCount(
        userId: userId,
        builder: (context, count, unverified, esc) {
          if (count == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Nothing needs attention.',
                    textAlign: TextAlign.center),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (esc != SyncEscalation.none) ...[
                _sectionHeader(context, 'Backup'),
                _BackupItem(esc: esc),
                const Divider(),
              ],
              if (unverified.isNotEmpty) ...[
                _sectionHeader(
                    context, 'Unverified entries (${unverified.length})'),
                ...unverified.map((e) => _UnverifiedRow(entry: e)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String t) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(t.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium),
      );
}

/// Item type 2 — backup not syncing (FSD §3.4; Architecture §2.5.1 LG-2).
class _BackupItem extends StatefulWidget {
  final SyncEscalation esc;
  const _BackupItem({required this.esc});

  @override
  State<_BackupItem> createState() => _BackupItemState();
}

class _BackupItemState extends State<_BackupItem> {
  late final Stream<int> _pending = Drain.watchPendingCount();

  @override
  Widget build(BuildContext context) {
    final isAuth = widget.esc == SyncEscalation.auth;
    final reason = isAuth
        ? "Backup can't sign in. Re-secure it to keep backing up."
        : "Backup hasn't succeeded in the last "
            '${SyncHealth.escalationThreshold} tries.';
    return StreamBuilder<int>(
      stream: _pending,
      builder: (context, snap) {
        final pending = snap.data ?? 0;
        return ListTile(
          leading: Icon(Icons.cloud_off,
              color: Theme.of(context).colorScheme.error),
          title: const Text('Backup not syncing'),
          subtitle: Text('$reason\n$pending waiting to back up'),
          isThreeLine: true,
          trailing: isAuth
              // Re-link flow is Stage 6 (FSD §5.4); shown disabled until then.
              ? const OutlinedButton(
                  onPressed: null, child: Text('Re-secure backup'))
              : OutlinedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Retrying backup…')));
                    await SyncTriggers.runNow('retry');
                  },
                  child: const Text('Retry now'),
                ),
        );
      },
    );
  }
}

/// Item type 1 — unverified entry (FSD §3.4). Tap -> review (Stage 5d).
class _UnverifiedRow extends StatelessWidget {
  final FoodEntry entry;
  const _UnverifiedRow({required this.entry});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final t = entry.entryTimestamp.toLocal();
    final date = '${_months[t.month - 1]} ${t.day}';
    final left = verificationDaysLeft(entry.entryTimestamp);
    final window = left > 0
        ? '$left day${left == 1 ? '' : 's'} left'
        : 'Confirm only';
    return ListTile(
      title: Text(entry.name),
      subtitle: Text('$date · ${mealTypeLabel(entry.mealType)} · unverified'),
      trailing: Text(window,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: left > 0 && left <= 2
                  ? Theme.of(context).colorScheme.error
                  : null)),
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => VerifyReviewScreen(entry: entry),
      )),
    );
  }
}
