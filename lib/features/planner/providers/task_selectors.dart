import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../services/task_ia_service.dart';
import 'task_provider.dart';
import '../../calendar/providers/calendar_provider.dart';

// Computed Provider: Tasks filtered by selected date (Performance optimized)
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(taskProvider);
  final selectedDate = calendarState.selectedDate.value;

  return allTasks.where((t) {
    if (t.date == null) return false;
    return DateUtils.isSameDay(t.date, selectedDate);
  }).toList();
});

// Computed: Active tasks only
final activeTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now();

  return tasks.where((t) {
    if (t.isDone || t.isIgnored) return false;
    if (TaskIaService.isTaskOverdue(t, now)) return false;
    return true;
  }).toList();
});

// Computed: Ignored tasks only
final ignoredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now();

  final List<Task> ignored = [];

  for (final t in tasks) {
    if (t.isDone) continue;

    // Explicitly ignored
    if (t.isIgnored) {
      ignored.add(t);
      continue;
    }

    // Implicitly ignored (Overdue) -> Project as ignored for UI
    if (TaskIaService.isTaskOverdue(t, now)) {
      ignored.add(t.copyWith(isIgnored: true));
    }
  }

  return ignored;
});

// Computed: Completed tasks only
final completedTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(filteredTasksProvider).where((t) => t.isDone).toList();
});

// Computed: Daily Progress (0.0 to 1.0)
final taskProgressProvider = Provider<double>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  if (tasks.isEmpty) return 0.0;
  final done = tasks.where((t) => t.isDone).length;
  return done / tasks.length;
});
