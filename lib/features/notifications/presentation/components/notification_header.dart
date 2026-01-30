import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    required this.onBack,
    required this.onMarkAllRead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: ActionIcon(
              icon: AppIcons.chevronLeft(context),
              onTap: onBack,
              color: colors.textPrimary,
              size: 16,
              padding: const EdgeInsets.all(16),
            ),
          ),
          Text(
            'Notifications',
            style: context.h2.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          GlassCard(
            borderRadius: 20,
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: onMarkAllRead,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'MARK ALL READ',
                      style: context.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      AppIcons.checkDouble(context),
                      size: 14,
                      color: colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
