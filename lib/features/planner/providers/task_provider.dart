import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Computed: Active tasks only
final activeTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(filteredTasksProvider).where((t) => !t.isDone).toList();
});

// Computed: Completed tasks only
final completedTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(filteredTasksProvider).where((t) => t.isDone).toList();
});
