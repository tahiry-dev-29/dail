import 'package:daily_os/features/planner/data/stats_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:signals_flutter/signals_flutter.dart';

class StatsViewModel {
  final TaskListViewModel _taskListViewModel;

  StatsViewModel(this._taskListViewModel);

  late final monthlyStats = computed(() {
    final tasksAsync = _taskListViewModel.tasks.value;

    return tasksAsync.map(
      data: (allTasks) {
        final now = DateTime.now();

        List<MonthStat> stats = [];
        int maxCount = 0;
        int totalCount = 0;

        // Generate last 7 months (including current)
        for (int i = 6; i >= 0; i--) {
          final monthDate = DateTime(now.year, now.month - i, 1);
          final monthTasks = allTasks.where((t) {
            if (t.date == null) return false;
            return t.date!.year == monthDate.year &&
                t.date!.month == monthDate.month;
          }).length;

          if (monthTasks > maxCount) maxCount = monthTasks;
          totalCount += monthTasks;

          String label = _getMonthLabel(monthDate.month);

          stats.add(
            MonthStat(
              label: label,
              count: monthTasks,
              normalizedValue: 0, // Will set later
              isCurrentMonth: i == 0,
            ),
          );
        }

        // Normalize
        final normalizedStats = stats.map((s) {
          return MonthStat(
            label: s.label,
            count: s.count,
            normalizedValue: maxCount > 0 ? s.count / maxCount : 0.0,
            isCurrentMonth: s.isCurrentMonth,
          );
        }).toList();

        return MonthlyStats(
          stats: normalizedStats,
          totalTasksLast6Months: totalCount,
        );
      },
      loading: () => MonthlyStats(stats: [], totalTasksLast6Months: 0),
      error: (_) => MonthlyStats(stats: [], totalTasksLast6Months: 0),
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
    try {
      return frMonths[month - 1];
    } catch (e) {
      return '$month';
    }
  }
}
