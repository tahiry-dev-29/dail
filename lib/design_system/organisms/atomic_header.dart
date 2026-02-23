import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/views/bloc/calendar_view_model.dart';
import 'package:daily_os/features/notifications/views/screens/notifications_page.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:daily_os/features/settings/views/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AtomicHeader extends StatelessWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarVM = sl<CalendarViewModel>();
    final selectedDate = calendarVM.selectedDate.watch(context);
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(selectedDate);
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Row(
          children: [
            // 🍔 Menu Icon (Static / Disabled but visible)
            IconButton(
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () => Scaffold.of(context).openDrawer(),
              color: colors.textPrimary,
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  // Progress Indicator (Visual Restore)
                  const _SafeDayProgressIndicator(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateStr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  // Notifications with Navigation
                  IconButton(
                    icon: Icon(AppIcons.bell(context), size: 16),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    ),
                    color: colors.textPrimary,
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  // Settings with Navigation
                  IconButton(
                    icon: Icon(AppIcons.settings(context), size: 16),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    ),
                    color: colors.textPrimary,
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafeDayProgressIndicator extends StatelessWidget {
  const _SafeDayProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = sl<TaskListViewModel>().dailyProgress.watch(context);
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
  }
}
