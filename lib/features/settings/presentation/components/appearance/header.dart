import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onBack;
  const Header({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.chevronLeft(context),
                size: 14,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Apparence',
            style: context.h2.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
