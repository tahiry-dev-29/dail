import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/state/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVM = sl<SettingsViewModel>();
    final sounds = settingsVM.notificationSoundsEnabled.watch(context);
    final alerts = settingsVM.notificationAlertsEnabled.watch(context);
    final reminders = settingsVM.notificationRemindersEnabled.watch(context);
    final minutes = settingsVM.reminderMinutesBefore.watch(context);

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
                      AppIcons.chevronLeft(context),
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
                  icon: AppIcons.volume(context),
                  iconColor: Colors.blueAccent,
                  title: 'Sons',
                  subtitle: 'Sons de notification',
                  value: sounds,
                  onChanged: (v) => settingsVM.toggleNotificationSounds(v),
                ),
                _SettingsTile(
                  icon: AppIcons.bell(context),
                  iconColor: Colors.orangeAccent,
                  title: 'Alertes',
                  subtitle: 'Afficher les alertes push',
                  value: alerts,
                  onChanged: (v) => settingsVM.toggleNotificationAlerts(v),
                ),
                _SettingsTile(
                  icon: AppIcons.clock(context),
                  iconColor: Colors.greenAccent,
                  title: 'Rappels',
                  subtitle: 'Rappels avant les tâches',
                  value: reminders,
                  onChanged: (v) => settingsVM.toggleNotificationReminders(v),
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
                                onTap: () => settingsVM.setReminderMinutes(m),
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
