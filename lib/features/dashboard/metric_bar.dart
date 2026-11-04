import 'package:flutter/material.dart';

import 'day_totals.dart';

/// Dual-semantic progress bar (Decision 6). Build-up fills toward target (green);
/// stay-under fills toward limit, going amber as it nears and red once over. The
/// precise number sits inline. Shared by the dashboard and the entry impact panel.
class MetricBar extends StatelessWidget {
  final MetricRow row;
  const MetricBar(this.row, {super.key});

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final target = row.target!;
    final consumed = row.consumed;
    final frac = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    final Color color;
    if (row.kind == MetricKind.buildUp) {
      color = consumed >= target ? Colors.green.shade600 : Colors.green.shade400;
    } else if (consumed > target) {
      color = scheme.error;
    } else if (consumed > target * 0.85) {
      color = Colors.amber.shade700;
    } else {
      color = Colors.green.shade400;
    }

    final unit = row.unit == '% of cals' ? '%' : row.unit;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(row.label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: frac,
                minHeight: 8,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 96,
            child: Text(
              '${_fmt(consumed)} / ${_fmt(target)} $unit',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
