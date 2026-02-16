import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/views/bloc/calendar_view_model.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:daily_os/features/settings/views/bloc/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ProgressStatsCard extends StatelessWidget {
  const ProgressStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final taskListVM = sl<TaskListViewModel>();
    final calendarVM = sl<CalendarViewModel>();
    final themeVM = sl<ThemeViewModel>();
    final selectedDate = calendarVM.selectedDate.watch(context);

    // Watch tasks and filter by selected date
    final tasksAsync = taskListVM.tasks.watch(context);
    final allTasks = tasksAsync.value ?? [];

    final filteredTasks = allTasks.where((t) {
      if (t.date == null) return false;
      return DateUtils.isSameDay(t.date!, selectedDate);
    }).toList();

    final total = filteredTasks.length;
    final done = filteredTasks.where((t) => t.isDone).length;
    final remaining = total - done;
    final progress = total > 0 ? done / total : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;
        final statValueSize = isSmall ? 16.0 : 20.0;
        final statLabelSize = isSmall ? 8.0 : 10.0;

        return GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            children: [
              // Progress Header
              Text(
                'Progression',
                style: context.bodySmall.copyWith(color: colors.textSecondary),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress),
                duration: themeVM.getAdaptedDuration(
                  const Duration(milliseconds: 1000),
                ),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  '${(value * 100).toInt()}%',
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Progress Bar
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
                  duration: themeVM.getAdaptedDuration(
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
  final AdaptiveColors colors;
  final double valueSize;
  final double labelSize;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
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
              style: context.h2.copyWith(fontSize: valueSize, color: color),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: context.caption.copyWith(
                fontSize: labelSize,
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
