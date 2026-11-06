import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/core/bootstrap.dart';
import 'package:calorie_tracking_app/data/app_database.dart';

/// Which surface the saved-items list is serving (Slice 2 FSD §3.2).
enum SavedListMode {
  /// From the Entry screen: tap a row to add it as a card (FSD §3.1).
  pick,

  /// From Settings → Saved items: delete with confirmation (soft delete).
  delete,
}

/// The one saved-items list widget, two modes (FSD §3.2). Rows: name, base
/// portion, calories; A–Z (ordering comes from [SavedItemDao.watchActive]).
/// No editing in either mode (MARD §1.3). Body only — the caller supplies the
/// surrounding chrome (sheet / Scaffold), so pick and delete can differ there.
class SavedItemsList extends StatelessWidget {
  final String userId;
  final SavedListMode mode;

  /// Pick mode only: called with the tapped item. The list stays open.
  final ValueChanged<SavedItem>? onPick;

  const SavedItemsList({
    super.key,
    required this.userId,
    required this.mode,
    this.onPick,
  }) : assert(mode != SavedListMode.pick || onPick != null,
            'pick mode needs onPick');

  static String fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  static String portionLabel(SavedItem s) => '${fmt(s.quantity)} ${s.unit.name}';

  Future<void> _confirmDelete(BuildContext context, SavedItem s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete saved item?'),
        content: Text(
          '"${s.name}" (${portionLabel(s)} · ${fmt(s.calories)} kcal) will be '
          'removed from your library. Past entries are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await db.savedItemDao.softDelete(s); // soft delete + enqueue (FSD §5.2)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted "${s.name}"')),
      );
    }
  }

  /// Opens pick mode as a half-height sheet over the Entry screen (4e option
  /// A). The header keeps a running "+N items · +X kcal" so the impact of picks
  /// is visible while the sheet covers the pinned panel; Done closes it.
  static Future<void> showPickSheet(
    BuildContext context, {
    required String userId,
    required ValueChanged<SavedItem> onPick,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.6,
          child: _PickSheet(userId: userId, onPick: onPick),
        ),
      );

  /// Opens delete mode as a full screen (Settings → Saved items).
  static Future<void> openManage(BuildContext context,
          {required String userId}) =>
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Saved items')),
          body: SavedItemsList(userId: userId, mode: SavedListMode.delete),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SavedItem>>(
      stream: db.savedItemDao.watchActive(userId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data!;
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No saved items yet.\n'
                'Tick "Save to library" on a card when you log it.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final s = items[i];
            return ListTile(
              title: Text(s.name),
              subtitle: Text(portionLabel(s)),
              trailing: mode == SavedListMode.pick
                  ? Text('${fmt(s.calories)} kcal')
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${fmt(s.calories)} kcal'),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmDelete(context, s),
                        ),
                      ],
                    ),
              onTap: mode == SavedListMode.pick ? () => onPick!(s) : null,
            );
          },
        );
      },
    );
  }
}

/// Pick-mode chrome: header (title, running total, Done) + the list.
class _PickSheet extends StatefulWidget {
  final String userId;
  final ValueChanged<SavedItem> onPick;
  const _PickSheet({required this.userId, required this.onPick});

  @override
  State<_PickSheet> createState() => _PickSheetState();
}

class _PickSheetState extends State<_PickSheet> {
  int _count = 0;
  double _kcal = 0;

  void _pick(SavedItem s) {
    widget.onPick(s);
    setState(() {
      _count++;
      _kcal += s.calories; // picks land at base portion
    });
  }

  @override
  Widget build(BuildContext context) {
    final summary = _count == 0
        ? 'Tap an item to add it'
        : '+$_count item${_count == 1 ? '' : 's'} · '
            '+${SavedItemsList.fmt(_kcal)} kcal';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saved items',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(summary,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SavedItemsList(
            userId: widget.userId,
            mode: SavedListMode.pick,
            onPick: _pick,
          ),
        ),
      ],
    );
  }
}
