import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/task_model.dart';
import '../data/subtask_model.dart';
import '../../calendar/providers/calendar_provider.dart';

class TaskNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    // Initial mock data
    final today = DateTime.now();
    return [
      Task(
        id: '1',
        name: 'Morning Routine',
        time: '07:00',
        isDone: true,
        date: today,
      ),
      Task(
        id: '2',
        name: 'Deep Work',
        time: '09:00',
        isDone: false,
        isFavorite: true,
        date: today,
      ),
      Task(
        id: '3',
        name: 'Gym',
        time: '18:00',
        isDone: false,
        date: today,
        deadline: DateTime(today.year, today.month, today.day, 19, 0),
      ),
    ];
  }

  void addTask({
    required String name,
    required String time,
    String description = '',
    DateTime? date,
    DateTime? deadline,
    bool isFavorite = false,
  }) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      time: time,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
    );
    state = [...state, newTask]..sort((a, b) => a.time.compareTo(b.time));
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ];
  }

  void deleteTask(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void toggleFavorite(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(isFavorite: !task.isFavorite)
        else
          task,
    ];
  }

  void toggleIgnore(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isIgnored: !task.isIgnored) else task,
    ];
  }

  void addSubtask(
    String taskId,
    String name, {
    String description = '',
    String time = '00:00',
    DateTime? deadline,
    bool isFavorite = false,
  }) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            subtasks: [
              ...task.subtasks,
              SubTask(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                description: description,
                time: time,
                deadline: deadline,
                isFavorite: isFavorite,
              ),
            ],
          )
        else
          task,
    ];
  }

  void toggleSubtask(String taskId, String subtaskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            subtasks: [
              for (final st in task.subtasks)
                if (st.id == subtaskId) st.copyWith(isDone: !st.isDone) else st,
            ],
          )
        else
          task,
    ];
  }

  void deleteSubtask(String taskId, String subtaskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            subtasks: task.subtasks.where((st) => st.id != subtaskId).toList(),
          )
        else
          task,
    ];
  }

  void updateSubtask(String taskId, SubTask updatedSubtask) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            subtasks: [
              for (final st in task.subtasks)
                if (st.id == updatedSubtask.id) updatedSubtask else st,
            ],
          )
        else
          task,
    ];
  }

  void promoteSubtaskToTask(String taskId, String subtaskId) {
    // 1. Find the subtask
    final parentTask = state.firstWhere((t) => t.id == taskId);
    final subtask = parentTask.subtasks.firstWhere((st) => st.id == subtaskId);

    // 2. Remove subtask from parent
    deleteSubtask(taskId, subtaskId);

    // 3. Add as new main task
    addTask(
      name: subtask.name,
      description: subtask.description,
      time: subtask.time,
      date: parentTask.date,
      deadline: subtask.deadline,
      isFavorite: subtask.isFavorite,
    );
  }

  // Refresh tasks (for pull-to-refresh)
  Future<void> refreshTasks() async {
    // In real app, fetch from API here
    await Future.delayed(const Duration(milliseconds: 300));
    // Trigger rebuild
    state = [...state];
  }

  void updateTask(Task updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // 1. Separate Active (Reorderable) and Done (Static)
    // 1. Separate Active (Reorderable), Done (Static), and Ignored
    final activeTasks = state.where((t) => !t.isDone && !t.isIgnored).toList();
    final doneTasks = state.where((t) => t.isDone).toList();
    final ignoredTasks = state.where((t) => t.isIgnored && !t.isDone).toList();

    // Safety check
    if (oldIndex >= activeTasks.length || newIndex > activeTasks.length) {
      return;
    }

    // 2. Capture times ONLY from active tasks (we exchange times between them)
    final activeTimes = activeTasks.map((t) => t.time).toList();

    // 3. Reorder the Active tasks list
    final item = activeTasks.removeAt(oldIndex);
    activeTasks.insert(newIndex, item);

    // 4. Re-assign the original Active times to the tasks in their new positions
    // This effectively "swaps" the tasks into the existing time slots
    final reorderedActiveTasks = <Task>[];
    for (int i = 0; i < activeTasks.length; i++) {
      if (i < activeTimes.length) {
        reorderedActiveTasks.add(activeTasks[i].copyWith(time: activeTimes[i]));
      } else {
        reorderedActiveTasks.add(activeTasks[i]);
      }
    }

    // 5. Merge back: Active + Done
    // Note: We might want to resort 'Done' tasks or keep them as is.
    // Usually, Done tasks stay at the bottom or are filtered out.
    // For safety, we just concat them.
    // 5. Merge back: Active + Done + Ignored
    state = [...reorderedActiveTasks, ...doneTasks, ...ignoredTasks];
  }

  void demoteTask(String taskId, {String? targetParentId}) {
    final index = state.indexWhere((t) => t.id == taskId);
    if (index == -1) return; // Not found

    final taskToDemote = state[index];

    int parentIndex = -1;
    if (targetParentId != null) {
      parentIndex = state.indexWhere((t) => t.id == targetParentId);
    } else if (index > 0) {
      parentIndex = index - 1;
    }

    if (parentIndex == -1) return; // No valid parent found

    final parentTask = state[parentIndex];

    // Create subtask from task
    final newSubtask = SubTask(
      id: taskToDemote.id,
      name: taskToDemote.name,
      description: taskToDemote.description,
      time: taskToDemote.time,
      deadline: taskToDemote.deadline,
      isFavorite: taskToDemote.isFavorite,
      isDone: taskToDemote.isDone,
    );

    // Update parent with new subtask
    final updatedParent = parentTask.copyWith(
      subtasks: [...parentTask.subtasks, newSubtask],
    );

    // Remove demoted task and update parent
    // Simplest: Remove child first.
    final items = [...state];
    items.removeAt(index);

    // Find parent index in NEW list (items)
    final newParentIndex = items.indexWhere((t) => t.id == parentTask.id);
    if (newParentIndex != -1) {
      items[newParentIndex] = updatedParent;
      state = items;
    }
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);

// Computed Provider: Tasks filtered by selected date (Performance optimized)
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(taskProvider);
  final selectedDate = calendarState.selectedDate.value;

  return allTasks.where((t) {
    if (t.date == null) return false;
    return DateUtils.isSameDay(t.date, selectedDate);
  }).toList();
});

// Helper to check if a task is overdue (IA Auto-Ignore Logic)
// A task is overdue if:
// 1. Its date is in the past (before today)
// 2. Its date is today AND its time has already passed
bool _isTaskOverdue(Task t, DateTime now) {
  // Skip already handled states
  if (t.isDone || t.isIgnored) return false;

  // If no date, cannot be overdue (treat as valid)
  if (t.date == null) return false;

  final today = DateTime(now.year, now.month, now.day);
  final taskDate = DateTime(t.date!.year, t.date!.month, t.date!.day);

  // Case 1: Task date is before today -> OVERDUE
  if (taskDate.isBefore(today)) {
    debugPrint(
      '[IA] Task "${t.name}" is OVERDUE: date ${t.date} is before today $today',
    );
    return true;
  }

  // Case 2: Task date is today -> Check time
  if (taskDate.isAtSameMomentAs(today)) {
    try {
      final parts = t.time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0].trim());
        final minute = int.parse(parts[1].trim());
        final taskDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        final isPastTime = taskDateTime.isBefore(now);

        if (isPastTime) {
          debugPrint(
            '[IA] Task "${t.name}" is OVERDUE: ${t.time} < ${now.hour}:${now.minute}',
          );
        }

        return isPastTime;
      }
    } catch (e) {
      debugPrint('[IA] Error parsing time for "${t.name}": $e');
    }
  }

  // Case 3: Task date is in the future -> NOT overdue
  return false;
}

// Computed: Active tasks only
final activeTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now(); // Server Time

  return tasks.where((t) {
    if (t.isDone || t.isIgnored) return false;
    if (_isTaskOverdue(t, now)) return false; // Hide if overdue
    return true;
  }).toList();
});

// Computed: Ignored tasks only
final ignoredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final now = DateTime.now(); // Server Time

  final List<Task> ignored = [];

  for (final t in tasks) {
    if (t.isDone) continue;

    // Explicitly ignored
    if (t.isIgnored) {
      ignored.add(t);
      continue;
    }

    // Implicitly ignored (Overdue) -> Project as ignored for UI
    if (_isTaskOverdue(t, now)) {
      ignored.add(t.copyWith(isIgnored: true));
    }
  }

  return ignored;
});

// Computed: Completed tasks only
final completedTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(filteredTasksProvider).where((t) => t.isDone).toList();
});

// =============================================================================
// STATISTICS PROVIDERS (Real Data)
// =============================================================================

class MonthStat {
  final String label;
  final int count;
  final double normalizedValue;
  final bool isCurrentMonth;

  MonthStat({
    required this.label,
    required this.count,
    required this.normalizedValue,
    required this.isCurrentMonth,
  });
}

class MonthlyStats {
  final List<MonthStat> stats;
  final int totalTasksLast6Months;

  MonthlyStats({required this.stats, required this.totalTasksLast6Months});
}

// Provider for Monthly Stats (Real Data Aggregation)
final monthlyTaskStatsProvider = Provider<MonthlyStats>((ref) {
  final allTasks = ref.watch(taskProvider);
  final now = DateTime.now();

  List<MonthStat> stats = [];
  int maxCount = 0;
  int totalCount = 0;

  // Generate last 7 months (including current)
  for (int i = 6; i >= 0; i--) {
    final monthDate = DateTime(now.year, now.month - i, 1);
    final monthTasks = allTasks.where((t) {
      if (t.date == null) return false;
      return t.date!.year == monthDate.year && t.date!.month == monthDate.month;
    }).length;

    if (monthTasks > maxCount) maxCount = monthTasks;
    totalCount += monthTasks;

    // Format label (e.g., JAN, FEV)
    String label = '';
    try {
      label = DateFormat('MMM', 'en_US').format(monthDate).toUpperCase();
      // Using en_US for standard 3-letter months (JAN, FEB) or fr_FR if prefered.
      // Given 'JUI' in reference, assume FR but let's stick to system locale logic if possible,
      // but hardcoded FR for now to match UI ref.
      const frMonths = [
        'JAN',
        'FEV',
        'MAR',
        'AVR',
        'MAI',
        'JUIN',
        'JUIL',
        'AOU',
        'SEP',
        'OCT',
        'NOV',
        'DEC',
      ];
      label = frMonths[monthDate.month - 1];
      if (label.length > 3) label = label.substring(0, 3);
    } catch (e) {
      label = '${monthDate.month}';
    }

    stats.add(
      MonthStat(
        label: label,
        count: monthTasks,
        normalizedValue: 0, // Will set later
        isCurrentMonth: i == 0,
      ),
    );
  }

  // Normalize
  final normalizedStats = stats.map((s) {
    return MonthStat(
      label: s.label,
      count: s.count,
      normalizedValue: maxCount > 0 ? s.count / maxCount : 0.0,
      isCurrentMonth: s.isCurrentMonth,
    );
  }).toList();

  return MonthlyStats(
    stats: normalizedStats,
    totalTasksLast6Months: totalCount,
  );
});
