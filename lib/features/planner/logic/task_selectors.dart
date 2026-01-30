import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/services/task_ia_service.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:daily_os/features/calendar/presentation/providers/calendar_provider.dart';

// Computed Provider: Tasks filtered by selected date (Performance optimized)
final filteredTasksProvider = Provider<List<TaskEntity>>((ref) {
  // 2026 Bridge Fix: Avoid circular initialization by skipping the first call
  // which is triggered immediately upon subscription.
  bool initialized = false;
  final sub = calendarState.selectedDate.subscribe((_) {
    if (initialized) {
      // Delay invalidation to ensure it happens outside the build phase
      Future.microtask(() => ref.invalidateSelf());
    }
  });
  ref.onDispose(sub);
  initialized = true;

  final allTasksAsync = ref.watch(taskListProvider);
  final allTasks = allTasksAsync.value ?? [];
  final selectedDate = calendarState.selectedDate.value;

  return allTasks.where((t) {
    if (t.date == null) return false;
    return DateUtils.isSameDay(t.date!, selectedDate);
  }).toList();
});

// Computed: Active tasks only
final activeTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now();

  return tasks.where((t) {
    if (t.isDone || t.isIgnored) return false;
    if (TaskIaService.isTaskOverdue(t, now)) return false;
    return true;
  }).toList();
});

// Computed: Ignored tasks only
final ignoredTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now();

  final List<TaskEntity> ignored = [];

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
final completedTasksProvider = Provider<List<TaskEntity>>((ref) {
  return ref.watch(filteredTasksProvider).where((t) => t.isDone).toList();
});

// Computed: Daily Progress (0.0 to 1.0)
final taskProgressProvider = Provider<double>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  if (tasks.isEmpty) return 0.0;
  final done = tasks.where((t) => t.isDone).length;
  return done / tasks.length;
});
