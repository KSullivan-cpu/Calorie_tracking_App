import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/sync/backup_link.dart';

/// The one email-link flow (FSD §3.5/§5.4), shared by Settings → Backup and
/// the dashboard nudge (Stage 6c). Fire-and-continue: returns once the link
/// request is answered; confirmation happens whenever the email is tapped.
Future<void> startLinkEmailFlow(BuildContext context) async {
  final email = await showDialog<String>(
    context: context,
    builder: (_) => _EmailDialog(initial: BackupLink.status.value.email),
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
      await _restoreOrCancel(context);
    case LinkRequestResult.offline:
      snack('You\'re offline. Linking needs a connection — try again when '
          'you\'re back online.');
    case LinkRequestResult.noSession:
      snack('Backup isn\'t signed in. Use Re-secure backup in Needs '
          'attention.');
    case LinkRequestResult.failed:
      snack('Couldn\'t send the link: ${out.error ?? 'unknown error'}');
  }
}

/// CG-2 (FSD §3.5): the email already belongs to a backup identity.
Future<void> _restoreOrCancel(BuildContext context) async {
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
    // Stage 7 (FSD §5.5 from step 3). Device and link status unchanged.
    debugPrint('BackupLink: restore chosen (stub until Stage 7)');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Restore isn\'t built yet (Stage 7). Nothing was '
            'changed.')));
  } else {
    debugPrint('BackupLink: existing backup — cancelled, device unchanged');
  }
}

/// Email entry. Returns the trimmed email, or null on cancel.
class _EmailDialog extends StatefulWidget {
  final String? initial;
  const _EmailDialog({this.initial});

  @override
  State<_EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<_EmailDialog> {
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
        title: const Text('Link an email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('We\'ll email you a link. Tap it any time to secure '
                'your backup — you can keep using the app meanwhile.'),
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
          FilledButton(onPressed: _submit, child: const Text('Send link')),
        ],
      );
}
