import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/sync/backup_link.dart';
import 'package:calorie_tracking_app/data/sync/drain.dart';
import 'package:calorie_tracking_app/features/attention/needs_attention.dart';
import 'package:calorie_tracking_app/features/settings/link_email_flow.dart';

/// Settings → Backup (Slice 2 FSD §3.5).
///
/// Stage 6a decisions (2026-11-11):
/// - Pending count = outbox rows, worded "changes" (it includes targets,
///   user and delete rows, not only food entries); 0 → "All changes backed up."
/// - Link status from [BackupLink] (shared_preferences `link_status_v1`).
/// - Needs-attention link always shown, with its count when non-empty.
/// Stage 6b/6c:
/// - Link email runs the shared [startLinkEmailFlow] (also used by the
///   dashboard nudge). Label "Resend or change email" while pending; hidden
///   once linked.
///
/// Stateful so the outbox watch is created once, not on every rebuild.
class BackupSection extends StatefulWidget {
  final String userId;
  const BackupSection({super.key, required this.userId});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  late final Stream<int> _pending = Drain.watchPendingCount();

  String _statusText(LinkStatus s) => switch (s.state) {
        LinkState.none => 'Not linked — on-device only',
        LinkState.pending => 'Link pending — check your email',
        LinkState.linked => 'Linked: ${s.email ?? ''}',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 4),
          child: Text('Backup', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ValueListenableBuilder<LinkStatus>(
          valueListenable: BackupLink.status,
          builder: (context, link, _) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(link.state == LinkState.linked
                ? Icons.cloud_done_outlined
                : Icons.cloud_off_outlined),
            title: Text(_statusText(link)),
            subtitle: const Text(
                'Link an email so you can restore on a new phone.'),
          ),
        ),
        StreamBuilder<int>(
          stream: _pending,
          builder: (context, snap) {
            final n = snap.data;
            final text = n == null
                ? 'Checking backup…'
                : n == 0
                    ? 'All changes backed up.'
                    : '$n ${n == 1 ? 'change' : 'changes'} waiting to back up.';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.sync),
              title: Text(text),
            );
          },
        ),
        ValueListenableBuilder<LinkStatus>(
          valueListenable: BackupLink.status,
          builder: (context, link, _) {
            if (link.state == LinkState.linked) return const SizedBox.shrink();
            return Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () => startLinkEmailFlow(context),
                child: Text(link.state == LinkState.pending
                    ? 'Resend or change email'
                    : 'Link email'),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        NeedsAttentionLink(userId: widget.userId),
      ],
    );
  }
}
