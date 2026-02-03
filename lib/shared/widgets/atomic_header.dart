import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/notifications/presentation/screens/notifications_page.dart';
import 'package:daily_os/features/planner/logic/task_selectors.dart';
import 'package:daily_os/features/settings/presentation/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AtomicHeader extends StatelessWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final selectedDate = calendarState.selectedDate.value;
      final dateStr = DateFormat('d MMMM', 'fr_FR').format(selectedDate);
      final colors = context.colors;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const _DayProgressIndicator(),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        Text(
                          dateStr,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        Text(
                          'DAILY DATA',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GlassCard(
                  borderRadius: 50,
                  padding: .zero,
                  child: ActionIcon(
                    icon: AppIcons.bell(context),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    ),
                    color: colors.textPrimary,
                    size: 16,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 12),
                GlassCard(
                  borderRadius: 50,
                  padding: .zero,
                  child: ActionIcon(
                    icon: AppIcons.settings(context),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                    color: colors.textPrimary,
                    size: 16,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _DayProgressIndicator extends StatelessWidget {
  const _DayProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final progress = taskProgressSignal.value;
      final colors = context.colors;
      final percentage = (progress * 100).toInt();

      return SizedBox(
        height: 48,
        width: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 4,
              color: colors.textSecondary.withValues(alpha: 0.1),
              strokeCap: StrokeCap.round,
            ),
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              color: colors.accent,
              strokeCap: StrokeCap.round,
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      );
    });
  }
}
