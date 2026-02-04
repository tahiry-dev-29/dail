import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/state/stats_view_model.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MonthlyStatsCard extends StatelessWidget {
  const MonthlyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statsVM = sl<StatsViewModel>();

    // Watch Real Data via Signal
    final monthlyStats = statsVM.monthlyStats.watch(context);
    final count = monthlyStats.totalTasksLast6Months;
    // Calculate simple growth (mock logic for now)
    const growth = "+12%";

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 320;

        return GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVITÉ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$count Tâches',
                            style: context.h2.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      style: context.bodySmall.copyWith(
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
                height: isSmall ? 80 : 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: monthlyStats.stats.map((stat) {
                    return _MonthBar(
                      label: stat.label,
                      value: stat.normalizedValue,
                      isSelected: stat.isCurrentMonth,
                      colors: colors,
                      barWidth: isSmall ? 6.0 : 8.0,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MonthBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final bool isSelected;
  final AdaptiveColors colors;
  final double barWidth;

  const _MonthBar({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.colors,
    this.barWidth = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: value),
              duration: themeVM.getAdaptedDuration(
                const Duration(milliseconds: 1000),
              ),
              curve: Curves.easeOutBack,
              builder: (context, val, _) {
                final h = val <= 0 ? 4.0 : (70 * val);
                return Container(
                  width: barWidth,
                  height: h,
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
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: context.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
