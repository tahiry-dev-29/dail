import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/core/theme/adaptive_colors.dart'; // Add missing import
import 'package:daily_os/shared/widgets/glass_container.dart'; // Add missing import
import '../../../planner/providers/task_provider.dart';

class MonthlyStatsCard extends ConsumerWidget {
  const MonthlyStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Watch Real Data Provider
    final monthlyStats = ref.watch(monthlyTaskStatsProvider);
    final count = monthlyStats.totalTasksLast6Months;
    // Calculate simple growth (mock logic for now as we don't track 'previous period' explicitly yet,
    // or we could differ last month vs this month)
    final growth = "+12%";

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVITÉ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count Tâches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyStats.stats.map((stat) {
                return _MonthBar(
                  label: stat.label,
                  value: stat.normalizedValue,
                  isSelected: stat.isCurrentMonth,
                  colors: colors,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final bool isSelected;
  final AdaptiveColors colors;

  const _MonthBar({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: value <= 0 ? 4 : (70 * value), // Min height 4 for visibility
          decoration: BoxDecoration(
            color: isSelected
                ? colors.accent
                : colors.textSecondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
