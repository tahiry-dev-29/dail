import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/calendar/presentation/components/grid/calendar_day_tile.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarVM = sl<CalendarViewModel>();
    final daysInMonth = calendarVM.daysInMonth.watch(context);
    final firstDayOffset = calendarVM.firstDayOffset.watch(context);
    final selectedDate = calendarVM.selectedDate.watch(context);

    // Calculate total slots including empty ones before the 1st of the month
    // Offset: Mon=1...Sun=7. If 1st is Mon, offset is 0. If 1st is Tue, offset is 1.
    // Logic: (weekday - 1) empty slots before day 1.
    final emptySlots = firstDayOffset - 1;
    final totalSlots = daysInMonth + emptySlots;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < emptySlots) {
          return const SizedBox(); // Empty slot
        }

        final day = index - emptySlots + 1;
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

        return CalendarDayTile(
          day: day,
          isSelected: isSelected,
          isToday: isToday,
          onTap: () {
            calendarVM.selectDate(day);
            sl<HomeViewModel>().switchTab(1); // Navigate to Planner
          },
        );
      },
    );
  }
}
