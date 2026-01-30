import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    super.key,
    required this.onBack,
    required this.onMarkAllRead,
  });

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
                FontAwesomeIcons.chevronLeft,
                size: 14,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Notifications',
            style: context.h2.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMarkAllRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'MARK ALL READ',
                    style: context.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    FontAwesomeIcons.checkDouble,
                    size: 12,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
