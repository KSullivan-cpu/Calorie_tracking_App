import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/sync/backup_link.dart';
import 'package:calorie_tracking_app/data/sync/restore.dart';

/// The one email-link flow (FSD §3.5/§5.4), shared by Settings → Backup and
/// the dashboard nudge (Stage 6c). Fire-and-continue: returns once the link
/// request is answered; confirmation happens whenever the email is tapped.
Future<void> startLinkEmailFlow(BuildContext context) async {
  final email = await showDialog<String>(
    context: context,
    builder: (_) => EmailDialog(initial: BackupLink.status.value.email),
  );
  if (email == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  void snack(String m) => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  snack('Sending link…');
  final out = await BackupLink.requestLink(email);
  if (!context.mounted) return;

  switch (out.result) {
    case LinkRequestResult.sent:
      snack('Link sent to $email. Keep using the app — tap the link in the '
          'email whenever you\'re ready.');
    case LinkRequestResult.existingBackup:
      messenger.hideCurrentSnackBar();
      await _restoreOrCancel(context, email);
    case LinkRequestResult.offline:
      snack('You\'re offline. Linking needs a connection — try again when '
          'you\'re back online.');
    case LinkRequestResult.noSession:
      snack('Backup isn\'t signed in. Use Re-secure backup in Needs '
          'attention.');
    case LinkRequestResult.rateLimited:
      snack(BackupLink.rateLimitMessage);
    case LinkRequestResult.failed:
      snack('Couldn\'t send the link: ${out.error ?? 'unknown error'}');
  }
}

/// CG-2 (FSD §3.5): the email already belongs to a backup identity.
/// Stage 7c: Restore → the same restore sign-in as onboarding (stash this
/// phone's session, magic link to the backup identity). Tapping the link
/// opens the restore screen, which confirms data exists and warns that this
/// phone's data will be replaced. Cancel there switches back.
Future<void> _restoreOrCancel(BuildContext context, String email) async {
  final restore = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('This email has an existing backup'),
      content: const Text('Restore it? This replaces this phone\'s data with '
          'the backup. Or cancel to leave this phone as it is.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Restore'),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  if (restore == true) {
    debugPrint('BackupLink: restore chosen for $email');
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Sending link…')));
    final r = await Restore.start(email);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(switch (r) {
        RestoreStart.sent => 'Sign-in link sent to $email. Tap it on this '
            'phone to restore — nothing changes until you confirm.',
        RestoreStart.noBackup => 'No backup found for $email.',
        RestoreStart.offline =>
          'You\'re offline. Restoring needs a connection.',
        RestoreStart.rateLimited => BackupLink.rateLimitMessage,
        RestoreStart.failed => 'Couldn\'t send the link. Try again.',
      })));
  } else {
    debugPrint('BackupLink: existing backup — cancelled, device unchanged');
  }
}

/// Email entry. Returns the trimmed email, or null on cancel. Shared by the
/// link flow and the onboarding restore entry (Stage 7a).
class EmailDialog extends StatefulWidget {
  final String? initial;
  final String title;
  final String message;
  final String action;
  const EmailDialog({
    super.key,
    this.initial,
    this.title = 'Link an email',
    this.message = 'We\'ll email you a link. Tap it any time to secure '
        'your backup — you can keep using the app meanwhile.',
    this.action = 'Send link',
  });

  @override
  State<EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  late final _ctrl = TextEditingController(text: widget.initial ?? '');
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _ctrl.text.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) {
      setState(() => _error = 'Enter a valid email address.');
      return;
    }
    Navigator.pop(context, email);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _error,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(onPressed: _submit, child: Text(widget.action)),
        ],
      );
}
