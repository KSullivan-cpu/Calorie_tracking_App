import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/enums.dart';

/// Macro-supplement guidance (Slice 3 FSD §3.2, D9; MARD §5.5.5).
const String kMacroSupplementHelp =
    'Protein powder, fiber, or anything with calories? Log it as food so it '
    'counts toward your macros.';

/// Shared add / edit supplement dialog (Slice 3 FSD §3.2). Used by Settings
/// now and by onboarding in Stage 4. Save is the confirm (Stage 2 decision);
/// it writes immediately. Returns true when something was saved.
Future<bool?> showSupplementDialog(
  BuildContext context, {
  required String userId,
  TrackedSupplement? existing,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => _SupplementDialog(userId: userId, existing: existing),
    );

class _SupplementDialog extends StatefulWidget {
  final String userId;
  final TrackedSupplement? existing;
  const _SupplementDialog({required this.userId, this.existing});

  @override
  State<_SupplementDialog> createState() => _SupplementDialogState();
}

class _SupplementDialogState extends State<_SupplementDialog> {
  // Owned by the dialog's own State (Slice 2 lesson: disposing them after
  // showDialog returns crashes the exit animation).
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _count = TextEditingController(
      text: '${widget.existing?.dailyTargetCount ?? 1}');
  late SupplementType _type =
      widget.existing?.type ?? SupplementType.dailyTarget;

  String? _nameError;
  String? _countError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _count.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    setState(() {
      _nameError = null;
      _countError = null;
    });
    if (name.isEmpty) {
      setState(() => _nameError = 'Enter a name');
      return;
    }
    int? count;
    if (_type == SupplementType.dailyTarget) {
      count = int.tryParse(_count.text.trim());
      if (count == null || count < 1) {
        setState(() => _countError = 'Whole number, 1 or more');
        return;
      }
    }

    setState(() => _saving = true);
    final dao = db.trackedSupplementDao;
    if (await dao.nameTaken(widget.userId, name,
        excludeId: widget.existing?.id)) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _nameError = 'You already track $name';
      });
      return;
    }

    final existing = widget.existing;
    if (existing == null) {
      await dao.add(widget.userId,
          name: name, type: _type, dailyTargetCount: count);
    } else {
      await dao.edit(existing,
          name: name, type: _type, dailyTargetCount: count);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? 'Edit supplement' : 'Add supplement'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              autofocus: !editing,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _nameError,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<SupplementType>(
              segments: const [
                ButtonSegment(
                    value: SupplementType.dailyTarget,
                    label: Text('Daily target')),
                ButtonSegment(
                    value: SupplementType.asNeeded, label: Text('As needed')),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            if (_type == SupplementType.dailyTarget) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _count,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Times per day',
                  errorText: _countError,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(kMacroSupplementHelp,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
