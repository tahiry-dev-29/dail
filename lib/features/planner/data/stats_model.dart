class MonthStat {
  final String label;
  final int count;
  final double normalizedValue;
  final bool isCurrentMonth;

  MonthStat({
    required this.label,
    required this.count,
    required this.normalizedValue,
    required this.isCurrentMonth,
  });
}

class MonthlyStats {
  final List<MonthStat> stats;
  final int totalTasksLast6Months;

  MonthlyStats({required this.stats, required this.totalTasksLast6Months});
}
