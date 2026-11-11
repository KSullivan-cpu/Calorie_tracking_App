import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/sync/backup_link.dart';
import 'package:calorie_tracking_app/data/sync/drain.dart';
import 'package:calorie_tracking_app/features/attention/needs_attention.dart';

/// Settings → Backup (Slice 2 FSD §3.5).
///
/// Stage 6a decisions (2026-11-11):
/// - Pending count = outbox rows, worded "changes" (it includes targets,
///   user and delete rows, not only food entries); 0 → "All changes backed up."
/// - Link status from [BackupLink] (shared_preferences `link_status_v1`).
/// - Link email: 6b magic-link flow (fire-and-continue). Label is
///   "Resend or change email" while pending; hidden once linked.
/// - Email already has a backup (CG-2) -> restore-or-cancel; Restore is a
///   stub until Stage 7.
/// - Needs-attention link always shown, with its count when non-empty.
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
  bool _busy = false;

  Future<void> _linkEmail(LinkStatus current) async {
    final email = await showDialog<String>(
      context: context,
      builder: (_) => _EmailDialog(initial: current.email),
    );
    if (email == null || !mounted) return;

    setState(() => _busy = true);
    final out = await BackupLink.requestLink(email);
    if (!mounted) return;
    setState(() => _busy = false);

    final messenger = ScaffoldMessenger.of(context);
    void snack(String m) =>
        messenger.showSnackBar(SnackBar(content: Text(m)));

    switch (out.result) {
      case LinkRequestResult.sent:
        snack('Link sent to $email. Keep using the app — tap the link '
            'in the email whenever you\'re ready.');
      case LinkRequestResult.existingBackup:
        await _restoreOrCancel();
      case LinkRequestResult.offline:
        snack('You\'re offline. Linking needs a connection — try again '
            'when you\'re back online.');
      case LinkRequestResult.noSession:
        snack('Backup isn\'t signed in. Use Re-secure backup in Needs '
            'attention.');
      case LinkRequestResult.failed:
        snack('Couldn\'t send the link: ${out.error ?? 'unknown error'}');
    }
  }

  /// CG-2 (FSD §3.5): the email already belongs to a backup identity.
  Future<void> _restoreOrCancel() async {
    final restore = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('This email has an existing backup'),
        content: const Text('Restore it? This replaces this phone\'s data '
            'with the backup. Or cancel to leave this phone as it is.'),
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
    if (!mounted) return;
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
                onPressed: _busy ? null : () => _linkEmail(link),
                child: Text(_busy
                    ? 'Sending…'
                    : link.state == LinkState.pending
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

/// Email entry for the link flow. Returns the trimmed email, or null on
/// cancel. Stateful so the controller is disposed properly.
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
