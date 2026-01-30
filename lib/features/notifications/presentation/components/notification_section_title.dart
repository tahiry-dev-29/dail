import 'package:flutter/material.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;

  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Text(
          title,
          style: context.caption.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: colors.border)),
      ],
    );
  }
}
