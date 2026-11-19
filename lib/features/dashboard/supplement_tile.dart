import 'package:flutter/material.dart';

import 'package:calorie_tracking_app/data/daos/supplement_entry_dao.dart';
import 'package:calorie_tracking_app/data/enums.dart';
import 'package:calorie_tracking_app/features/supplements/supplement_status.dart';

/// Dashboard supplement tile (Slice 3 FSD §3.4, Stage 3 S5 option A).
/// Same layout as MetricBar (80 label / bar / 96 text) so rows align, but
/// separate so the shared food/impact widget stays untouched (Rule 14).
/// Daily-target: build-up bar toward target, done / over markers from the
/// shared status helper (neutral, never stay-under red — D5).
/// As-needed: no bar, count today.
class SupplementTile extends StatelessWidget {
  final SupplementCount item;
  const SupplementTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = item.supplement;
    final st = supplementStatus(s, item.count);
    final small = Theme.of(context).textTheme.bodySmall;
    final target = s.dailyTargetCount;
    final hasBar = s.type == SupplementType.dailyTarget && target != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(s.name, style: small, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: hasBar
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: target > 0
                          ? (item.count / target).clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(st.done
                          ? Colors.green.shade600
                          : Colors.green.shade400),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 96,
            child: Text(
              st.label,
              textAlign: TextAlign.right,
              style: small,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
