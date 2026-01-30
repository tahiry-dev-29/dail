import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/screens/notification_settings_page.dart';
import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.accent;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: ActionIcon(
              icon: AppIcons.chevronLeft(context),
              onTap: () => Navigator.pop(context),
              color: colors.textPrimary,
              size: 16,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paramètres',
                  style: context.h1.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'DAILYOS AI',
                      style: context.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: ActionIcon(
              icon: AppIcons.bell(context),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsPage(),
                ),
              ),
              color: colors.textPrimary,
              size: 20,
              padding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.isDark ? Colors.white : Colors.grey[300]!,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
