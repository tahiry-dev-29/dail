import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = notificationSoundsEnabled.watch(context);
    final alerts = notificationAlertsEnabled.watch(context);
    final reminders = notificationRemindersEnabled.watch(context);
    final minutes = reminderMinutesBefore.watch(context);

    final colors = context.colors;

    return GlassScaffold(
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
              ],
            ),
          ),
          // Settings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _SettingsTile(
                  icon: FontAwesomeIcons.volumeHigh,
                  iconColor: Colors.blueAccent,
                  title: 'Sons',
                  subtitle: 'Sons de notification',
                  value: sounds,
                  onChanged: (v) => notificationSoundsEnabled.value = v,
                ),
                _SettingsTile(
                  icon: FontAwesomeIcons.bell,
                  iconColor: Colors.orangeAccent,
                  title: 'Alertes',
                  subtitle: 'Afficher les alertes push',
                  value: alerts,
                  onChanged: (v) => notificationAlertsEnabled.value = v,
                ),
                _SettingsTile(
                  icon: FontAwesomeIcons.clock,
                  iconColor: Colors.greenAccent,
                  title: 'Rappels',
                  subtitle: 'Rappels avant les tâches',
                  value: reminders,
                  onChanged: (v) => notificationRemindersEnabled.value = v,
                ),
                const SizedBox(height: 24),
                // Reminder time selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rappel avant la tâche',
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [5, 10, 15, 30]
                            .map(
                              (m) => _TimeChip(
                                minutes: m,
                                isSelected: minutes == m,
                                onTap: () => reminderMinutesBefore.value = m,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.caption.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.accent,
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = isSelected
        ? colors.accent
        : colors.textSecondary.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          '${minutes}m',
          style: context.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
