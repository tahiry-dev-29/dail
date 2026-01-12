import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../planner/providers/task_provider.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../core/theme/adaptive_colors.dart';

class ProgressStatsCard extends ConsumerWidget {
  const ProgressStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch filtered tasks (Today/Selected Date) instead of all tasks
    final tasks = ref.watch(filteredTasksProvider);
    final total = tasks.length;
    final done = tasks.where((t) => t.isDone).length;
    final remaining = total - done;
    final progress = total > 0 ? done / total : 0.0;

    final colors = context.colors;

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        children: [
          // Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 8,
            width: double.infinity, // Ensure full width
            decoration: BoxDecoration(
              color: colors.isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress > 0 ? progress : 0.05,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.cyanAccent, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Stats Grid
          Row(
            children: [
              _StatItem(
                label: 'TERMINEES',
                value: done,
                color: Colors.green,
                isDark: colors.isDark,
                colors: colors,
              ),
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  color: colors.border,
                  width: 1,
                  thickness: 1,
                ),
              ),
              _StatItem(
                label: 'RESTANTES',
                value: remaining,
                color: Colors.orange,
                isDark: colors.isDark,
                colors: colors,
              ),
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  color: colors.border,
                  width: 1,
                  thickness: 1,
                ),
              ),
              _StatItem(
                label: 'TOTAL',
                value: total,
                color: Colors.blue,
                isDark: colors.isDark,
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isDark;
  final AdaptiveColors colors;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
