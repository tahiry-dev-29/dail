import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:daily_os/features/planner/services/task_ia_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Computed signal: Tasks filtered by selected date.
final filteredTasksSignal = computed<List<TaskEntity>>(() {
  final state = plannerController.tasksSignal.value;
  final selectedDate = calendarState.selectedDate.value;

  return state.maybeMap(
    data: (tasks) => tasks.where((t) {
      if (t.date == null) return false;
      return DateUtils.isSameDay(t.date!, selectedDate);
    }).toList(),
    orElse: () => [],
  );
});

/// Computed signal: Filtered tasks categorized by status
final activeTasksSignal = computed<List<TaskEntity>>(() {
  final tasks = filteredTasksSignal.value;
  final now = DateTime.now();
  return tasks
      .where(
        (t) =>
            !t.isDone && !t.isIgnored && !TaskIaService.isTaskOverdue(t, now),
      )
      .toList();
});

final completedTasksSignal = computed<List<TaskEntity>>(() {
  return filteredTasksSignal.value.where((t) => t.isDone).toList();
});

final ignoredTasksSignal = computed<List<TaskEntity>>(() {
  final tasks = filteredTasksSignal.value;
  final now = DateTime.now();
  return tasks
      .where(
        (t) =>
            !t.isDone && (t.isIgnored || TaskIaService.isTaskOverdue(t, now)),
      )
      .toList();
});

/// Computed signal: Overall daily progress (0.0 to 1.0)
final taskProgressSignal = computed<double>(() {
  final tasks = filteredTasksSignal.value;
  if (tasks.isEmpty) return 0.0;
  final done = tasks.where((t) => t.isDone).length;
  return done / tasks.length;
});
