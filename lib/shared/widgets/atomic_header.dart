import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/notifications/presentation/screens/notifications_page.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/features/settings/presentation/screens/settings_page.dart';
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

class _DayProgressIndicator extends StatelessWidget {
  final DateTime selectedDate;

  const _DayProgressIndicator({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final taskListVM = sl<TaskListViewModel>();
    final tasksAsync = taskListVM.tasks.watch(context);
    final colors = context.colors;

    double progress = 0.0;

    final tasks = tasksAsync.value ?? [];
    final dayTasks = tasks.where((t) {
      if (t.date == null) return false;
      return DateUtils.isSameDay(t.date!, selectedDate);
    }).toList();

    if (dayTasks.isNotEmpty) {
      final completed = dayTasks.where((t) => t.isDone).length;
      progress = completed / dayTasks.length;
    }

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
