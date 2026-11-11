import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart' show cloudConfigured;
import 'package:calorie_tracking_app/data/sync/backup_link.dart';
import 'package:calorie_tracking_app/features/settings/link_email_flow.dart';

/// One-time dismissible backup nudge (Slice 2 FSD §3.7).
///
/// Stage 6c: shown while not linked and not dismissed; never gates anything.
/// Tapping it OR ✕ dismisses it permanently; tapping also opens the link flow.
class BackupNudge extends StatelessWidget {
  const BackupNudge({super.key});

  @override
  Widget build(BuildContext context) {
    if (!cloudConfigured) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: BackupLink.nudgeDismissed,
      builder: (context, dismissed, _) => ValueListenableBuilder<LinkStatus>(
        valueListenable: BackupLink.status,
        builder: (context, link, _) {
          if (dismissed || link.state != LinkState.none) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Secure your backup?'),
                subtitle: const Text(
                    'Link an email so you can restore on a new phone.'),
                trailing: IconButton(
                  tooltip: 'Dismiss',
                  icon: const Icon(Icons.close),
                  onPressed: BackupLink.dismissNudge,
                ),
                onTap: () async {
                  await BackupLink.dismissNudge();
                  if (context.mounted) await startLinkEmailFlow(context);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
