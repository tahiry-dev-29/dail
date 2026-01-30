import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/features/planner/data/stats_model.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';

// Provider for Monthly Stats (Real Data Aggregation)
final monthlyTaskStatsProvider = Provider<MonthlyStats>((ref) {
  final taskListAsync = ref.watch(taskListProvider);

  return taskListAsync.maybeWhen(
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

        if (monthTasks > maxCount) maxCount = monthTasks.toInt();
        totalCount += monthTasks;

        // Format label (e.g., JAN, FEV)
        String label = '';
        try {
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
          label = frMonths[monthDate.month - 1];
          if (label.length > 3) label = label.substring(0, 3);
        } catch (e) {
          label = '${monthDate.month}';
        }

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
    orElse: () => MonthlyStats(stats: [], totalTasksLast6Months: 0),
  );
});
