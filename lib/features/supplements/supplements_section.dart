import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/features/supplements/supplement_dialog.dart';

/// Settings → Supplements (Slice 3 FSD §3.2, D6). A–Z list with type and
/// target; tap to edit, trash to soft-delete (confirm), "Add supplement".
/// Rendered inside a collapsible Settings section.
class SupplementsSection extends StatelessWidget {
  final String userId;
  const SupplementsSection({super.key, required this.userId});

  static String describe(TrackedSupplement s) =>
      s.type == SupplementType.dailyTarget
          ? 'Daily · ${s.dailyTargetCount ?? 1}× a day'
          : 'As needed';

  Future<void> _confirmDelete(BuildContext context, TrackedSupplement s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${s.name}?'),
        content: const Text('It will no longer appear for logging. '
            'Past entries are kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await db.trackedSupplementDao.softDelete(s);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrackedSupplement>>(
      stream: db.trackedSupplementDao.watchActive(userId),
      builder: (context, snap) {
        final list = snap.data ?? const <TrackedSupplement>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (snap.hasData && list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No supplements yet.'),
              ),
            for (final s in list)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(s.name),
                subtitle: Text(describe(s)),
                onTap: () =>
                    showSupplementDialog(context, userId: userId, existing: s),
                trailing: IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, s),
                ),
              ),
            TextButton.icon(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => showSupplementDialog(context, userId: userId),
              icon: const Icon(Icons.add),
              label: const Text('Add supplement'),
            ),
          ],
        );
      },
    );
  }
}
