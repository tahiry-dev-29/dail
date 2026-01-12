import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/features/planner/providers/task_selectors.dart';
import '../../../../features/settings/providers/theme_provider.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;
        final statValueSize = isSmall ? 16.0 : 20.0;
        final statLabelSize = isSmall ? 8.0 : 10.0;

        return GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            children: [
              // Progress Header (ANIMATED TEXT)
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
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: progress),
                    duration: getAdaptedDuration(
                      const Duration(milliseconds: 1000),
                    ),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress Bar (ANIMATED WIDTH)
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: getAdaptedDuration(
                    const Duration(milliseconds: 1200),
                  ),
                  curve: Curves.easeOutBack,
                  builder: (context, value, _) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value > 0 ? value : 0.05,
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
                    valueSize: statValueSize,
                    labelSize: statLabelSize,
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
                    valueSize: statValueSize,
                    labelSize: statLabelSize,
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
                    valueSize: statValueSize,
                    labelSize: statLabelSize,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isDark;
  final AdaptiveColors colors;
  final double valueSize;
  final double labelSize;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.colors,
    this.valueSize = 20.0,
    this.labelSize = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
