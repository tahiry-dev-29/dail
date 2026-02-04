import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? AppIcons.search(context),
                size: 48,
                color: colors.accent.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.h2.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: context.bodyMedium.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
