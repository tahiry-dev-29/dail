import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/utils/glass_scaffold.dart';
import '../providers/settings_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = notificationSoundsEnabled.watch(context);
    final alerts = notificationAlertsEnabled.watch(context);
    final reminders = notificationRemindersEnabled.watch(context);
    final minutes = reminderMinutesBefore.watch(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textMuted = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black54;
    final surface = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);

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
                      color: surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 14,
                      color: textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
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
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  surface: surface,
                ),
                _SettingsTile(
                  icon: FontAwesomeIcons.bell,
                  iconColor: Colors.orangeAccent,
                  title: 'Alertes',
                  subtitle: 'Afficher les alertes push',
                  value: alerts,
                  onChanged: (v) => notificationAlertsEnabled.value = v,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  surface: surface,
                ),
                _SettingsTile(
                  icon: FontAwesomeIcons.clock,
                  iconColor: Colors.greenAccent,
                  title: 'Rappels',
                  subtitle: 'Rappels avant les tâches',
                  value: reminders,
                  onChanged: (v) => notificationRemindersEnabled.value = v,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  surface: surface,
                ),
                const SizedBox(height: 24),
                // Reminder time selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rappel avant la tâche',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
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
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                surface: surface,
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
  final Color textPrimary;
  final Color textMuted;
  final Color surface;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.textPrimary,
    required this.textMuted,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.blueAccent,
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
  final Color textPrimary;
  final Color textMuted;
  final Color surface;

  const _TimeChip({
    required this.minutes,
    required this.isSelected,
    required this.onTap,
    required this.textPrimary,
    required this.textMuted,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? Colors.blueAccent
        : textMuted.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          '${minutes}m',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : textMuted,
          ),
        ),
      ),
    );
  }
}
