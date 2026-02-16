import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int doneCount;
  final int remainingCount;

  const StatsGrid({
    super.key,
    required this.doneCount,
    required this.remainingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: AppIcons.circleCheck(context),
            iconColor: Colors.greenAccent,
            value: doneCount.toString(),
            label: 'Terminées',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: AppIcons.clock(context),
            iconColor: Colors.orangeAccent,
            value: remainingCount.toString(),
            label: 'Restantes',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: context.h2.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label.toUpperCase(),
                  style: context.caption.copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
