import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;

  const CalendarHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => calendarState.prevMonth(),
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        Text(
          DateFormat('MMMM yyyy').format(currentMonth).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          onPressed: () => calendarState.nextMonth(),
          icon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ],
    );
  }
}
