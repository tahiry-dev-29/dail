import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;

  const CalendarHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final contentColor = colors.textPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => calendarState.prevMonth(),
          icon: Icon(
            AppIcons.chevronLeft(context),
            color: contentColor,
            size: 16,
          ),
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
          icon: Icon(
            AppIcons.chevronRight(context),
            color: contentColor,
            size: 16,
          ),
        ),
      ],
    );
  }
}
