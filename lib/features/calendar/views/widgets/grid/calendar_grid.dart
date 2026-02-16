import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/calendar/views/widgets/grid/calendar_day_tile.dart';
import 'package:daily_os/features/calendar/views/bloc/calendar_view_model.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarVM = sl<CalendarViewModel>();
    final taskListVM = sl<TaskListViewModel>();

    final daysInMonth = calendarVM.daysInMonth.watch(context);
    final firstDayOffset = calendarVM.firstDayOffset.watch(context);
    final selectedDate = calendarVM.selectedDate.watch(context);
    final tasksState = taskListVM.tasks.watch(context);

    // Calculate total slots including empty ones before the 1st of the month
    final emptySlots = firstDayOffset - 1;
    final totalSlots = daysInMonth + emptySlots;

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < emptySlots) {
          return const SizedBox(); // Empty slot
        }

        final int day = index - emptySlots + 1;
        final currentDayDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          day,
        );
        final isSelected = selectedDate.day == day;

        final now = DateTime.now();
        final isToday =
            now.year == currentDayDate.year &&
            now.month == currentDayDate.month &&
            now.day == day;

        // Determine if day has tasks
        bool hasTasks = false;
        final tasks = tasksState.value;
        if (tasks != null) {
          hasTasks = tasks.any((task) {
            final tDate = (task).date;
            return tDate != null &&
                tDate.year == currentDayDate.year &&
                tDate.month == currentDayDate.month &&
                tDate.day == day;
          });
        }

        return CalendarDayTile(
          day: day,
          isSelected: isSelected,
          isToday: isToday,
          hasTasks: hasTasks,
          onTap: () {
            calendarVM.selectDate(day);
            sl<HomeViewModel>().switchTab(AppTabs.workspace.index);
            sl<WorkspaceViewModel>().showDashboard();
          },
        );
      },
    );
  }
}
