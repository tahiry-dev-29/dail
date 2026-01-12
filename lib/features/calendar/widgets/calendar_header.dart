import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;

  const CalendarHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => calendarState.prevMonth(),
          icon: Icon(Icons.chevron_left, color: contentColor),
        ),
        Text(
          DateFormat('MMMM yyyy').format(currentMonth).toUpperCase(),
          style: TextStyle(
            color: contentColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          onPressed: () => calendarState.nextMonth(),
          icon: Icon(Icons.chevron_right, color: contentColor),
        ),
      ],
    );
  }
}
