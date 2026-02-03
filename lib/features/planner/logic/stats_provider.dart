import 'package:daily_os/features/planner/data/stats_model.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Computed signal for Monthly Stats (Optimized with Signals)
final monthlyTaskStatsSignal = computed<MonthlyStats>(() {
  final state = plannerController.tasksSignal.value;

  return state.maybeMap(
    data: (allTasks) {
      final now = DateTime.now();
      List<MonthStat> stats = [];
      int maxCount = 0;
      int totalCount = 0;

      for (int i = 6; i >= 0; i--) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final monthTasks = allTasks.where((t) {
          if (t.date == null) return false;
          return t.date!.year == monthDate.year &&
              t.date!.month == monthDate.month;
        }).length;

        if (monthTasks > maxCount) maxCount = monthTasks;
        totalCount += monthTasks;

        final label = _getMonthLabel(monthDate.month);
        stats.add(
          MonthStat(
            label: label,
            count: monthTasks,
            normalizedValue: 0,
            isCurrentMonth: i == 0,
          ),
        );
      }

      final normalizedStats = stats
          .map(
            (s) => MonthStat(
              label: s.label,
              count: s.count,
              normalizedValue: maxCount > 0 ? s.count / maxCount : 0.0,
              isCurrentMonth: s.isCurrentMonth,
            ),
          )
          .toList();

      return MonthlyStats(
        stats: normalizedStats,
        totalTasksLast6Months: totalCount,
      );
    },
    orElse: () => MonthlyStats(stats: [], totalTasksLast6Months: 0),
  );
});

String _getMonthLabel(int month) {
  const frMonths = [
    'JAN',
    'FEV',
    'MAR',
    'AVR',
    'MAI',
    'JUIN',
    'JUIL',
    'AOU',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  if (month >= 1 && month <= 12) return frMonths[month - 1];
  return '$month';
}
