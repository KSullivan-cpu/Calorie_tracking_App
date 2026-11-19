import 'package:calorie_tracking_app/data/app_database.dart';
import 'package:calorie_tracking_app/data/enums.dart';

/// Display status for one supplement today (Stage 3 S2). Shared by the
/// quick-log rows and the dashboard tiles so the markers match (FSD §3.4).
class SupplementStatus {
  /// e.g. "1 / 2", "2 / 2 · done", "3 / 2 · over", "2 today".
  final String label;

  /// At or above target (daily-target only): greyed, still tickable (D5).
  final bool done;

  /// Above target: neutral marker, never stay-under red (D5).
  final bool over;

  const SupplementStatus(this.label, {this.done = false, this.over = false});
}

SupplementStatus supplementStatus(TrackedSupplement s, int count) {
  final target = s.dailyTargetCount;
  if (s.type == SupplementType.asNeeded || target == null) {
    return SupplementStatus('$count today');
  }
  if (count > target) {
    return SupplementStatus('$count / $target · over', done: true, over: true);
  }
  if (count >= target) {
    return SupplementStatus('$count / $target · done', done: true);
  }
  return SupplementStatus('$count / $target');
}
