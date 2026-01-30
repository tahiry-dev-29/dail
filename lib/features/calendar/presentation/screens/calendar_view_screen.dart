import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'package:daily_os/features/planner/domain/entities/task_entity.dart';

class CalendarViewScreen extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const CalendarViewScreen({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendrier 2026"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: MonthView<TaskEntity>(
        headerStyle: const HeaderStyle(
          decoration: BoxDecoration(color: Colors.transparent),
          headerTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onCellTap: (events, date) => onDateSelected(date),
        onEventTap: (events, date) => onDateSelected(date),
        cellAspectRatio: 0.8,
        useAvailableVerticalSpace: true,
      ),
    );
  }
}
