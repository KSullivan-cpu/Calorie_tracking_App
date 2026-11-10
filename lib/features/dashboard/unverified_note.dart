import 'package:flutter/material.dart';

/// "N unverified — not counted" (Slice 2 FSD §3.7, §4). Shared by the entry
/// impact panel (committed today + unverified drafts) and the dashboard
/// (committed today). Soft-committed items contribute zero until verified.
class UnverifiedNote extends StatelessWidget {
  final int count;
  const UnverifiedNote({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(Icons.help_outline, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$count unverified — not counted',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
