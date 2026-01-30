import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';

class StatsChart extends ConsumerWidget {
  const StatsChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsync = ref.watch(taskListProvider);
    final colors = context.colors;

    return taskListAsync.maybeWhen(
      data: (tasks) {
        final total = tasks.length;
        final done = tasks.where((t) => t.isDone).length;
        final percentage = total > 0 ? (done / total) : 0.0;

        return GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progression',
                    style: context.caption.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: context.bodyLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: colors.textPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.accent,
                          colors.accent.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Stats Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatLabel(
                    label: 'Terminées',
                    value: done.toString(),
                    color: Colors.greenAccent,
                    colors: colors,
                  ),
                  _StatLabel(
                    label: 'Restantes',
                    value: (total - done).toString(),
                    color: Colors.orangeAccent,
                    colors: colors,
                  ),
                  _StatLabel(
                    label: 'Total',
                    value: total.toString(),
                    color: colors.accent,
                    colors: colors,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final AdaptiveColors colors;

  const _StatLabel({
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: context.h2.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: context.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
