import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';

/// The name + replace decision from the save flow (FSD §3.1, G5).
class SaveTarget {
  final String name;

  /// Existing active item the user agreed to replace (soft-deleted on save).
  final SavedItem? replaces;
  const SaveTarget(this.name, this.replaces);
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

/// Shared "Save to library" flow (Stage 4d, reused by 4f): name dialog →
/// duplicate check → "Replace?". "No" on Replace returns to the name field.
/// Returns null if cancelled. Writes nothing — the caller decides when
/// (Entry: at commit; Frequent items: immediately).
Future<SaveTarget?> chooseSaveTarget(
  BuildContext context, {
  required String userId,
  required String initialName,
  required String hint,
}) async {
  var name = initialName;
  while (true) {
    if (!context.mounted) return null;
    final entered = await showDialog<String>(
      context: context,
      builder: (_) => SaveNameDialog(initial: name, hint: hint),
    );
    if (entered == null || entered.trim().isEmpty) return null; // cancelled
    name = entered.trim();
    final existing = await db.savedItemDao.findByName(userId, name);
    if (existing == null) return SaveTarget(name, null);
    if (!context.mounted) return null;
    if (await _askReplace(context, existing) == true) {
      return SaveTarget(name, existing);
    }
    // No -> back to the name field (rename or cancel)
  }
}

Future<bool?> _askReplace(BuildContext context, SavedItem existing) =>
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace?'),
        content: Text(
          'Your library already has "${existing.name}" '
          '(${_fmt(existing.quantity)} ${existing.unit.name} · '
          '${_fmt(existing.calories)} kcal). Replace it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );

/// The dialog owns its controller (disposed when the dialog's State is torn
/// down, AFTER the exit animation) — disposing it right after showDialog
/// returned crashed the still-animating TextField.
class SaveNameDialog extends StatefulWidget {
  final String initial;
  final String hint;
  const SaveNameDialog({super.key, required this.initial, required this.hint});

  @override
  State<SaveNameDialog> createState() => _SaveNameDialogState();
}

class _SaveNameDialogState extends State<SaveNameDialog> {
  late final _ctl = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save to library'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(widget.hint, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _ctl.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
