import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/notifications/presentation/screens/notifications_page.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:daily_os/features/settings/presentation/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AtomicHeader extends ConsumerWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = calendarState.selectedDate.watch(context);
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(selectedDate);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _DayProgressIndicator(selectedDate: selectedDate),
                const SizedBox(width: 16),
                Flexible(
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
              ],
            ),
          ),
          Row(
            children: [
              GlassCard(
                borderRadius: 50,
                padding: EdgeInsets.zero,
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
                padding: EdgeInsets.zero,
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
  }
}

class _DayProgressIndicator extends ConsumerWidget {
  final DateTime selectedDate;

  const _DayProgressIndicator({required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch tasks
    final tasksAsync = ref.watch(taskListProvider);
    final colors = context.colors;

    // Calculate progress
    double progress = 0.0;

    // Default to 0 if loading/error, or calculate if data available
    tasksAsync.whenData((tasks) {
      // Filter tasks for the selected date
      final dayTasks = tasks.where((t) {
        // If task has a specific date, match it.
        // If task has no date but is in the list, we might assume it's "today" or "backlog".
        // For "Daily Data", strictly matching the selected date seems appropriate.
        // If t.date is null, it might be a general task.
        // Let's assume we want tasks that are scheduled for this date.
        if (t.date == null) return false;
        return DateUtils.isSameDay(t.date!, selectedDate);
      }).toList();

      if (dayTasks.isNotEmpty) {
        final completed = dayTasks.where((t) => t.isDone).length;
        progress = completed / dayTasks.length;
      }
    });

    final percentage = (progress * 100).toInt();

    return SizedBox(
      height: 48,
      width: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            color: colors.textSecondary.withValues(alpha: 0.1),
            strokeCap: StrokeCap.round,
          ),
          // Progress
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
