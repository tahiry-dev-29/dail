import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Senior Controller for the Planner feature using Signals.
class PlannerController {
  final ITaskRepository _repository;

  PlannerController(this._repository);

  // --- Signals ---

  /// Main task list signal
  final tasksSignal = signal<AsyncState<List<TaskEntity>>>(
    const AsyncLoading(),
  );

  /// Initialize the controller and load tasks
  Future<void> init() async {
    await loadTasks();
  }

  /// Load tasks from repository
  Future<void> loadTasks() async {
    tasksSignal.value = const AsyncLoading();
    try {
      final tasks = await _repository.getTasks();
      tasksSignal.value = AsyncData(tasks);
    } catch (e, st) {
      tasksSignal.value = AsyncError(e, st);
    }
  }

  /// Add a new task
  Future<void> addTask({
    required String name,
    String description = '',
    required String time,
    DateTime? date,
    DateTime? deadline,
    bool isFavorite = false,
  }) async {
    final newTask = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      time: time,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
    );

    try {
      await _repository.addTask(newTask);
      await loadTasks();
    } catch (e) {
      // Log or handle error
      rethrow;
    }
  }

  /// Toggle task completion status
  Future<void> toggleTask(String id) async {
    try {
      await _repository.toggleTask(id);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  // --- Subtasks ---

  Future<void> addSubtask(String taskId, String name) async {
    final state = tasksSignal.value;
    if (state is AsyncData<List<TaskEntity>>) {
      final tasks = state.value;
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final task = tasks[taskIndex];
        final newSubtask = SubTaskEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
        );
        final updatedTask = task.copyWith(
          subtasks: [...task.subtasks, newSubtask],
        );
        await _repository.updateTask(updatedTask);
        await loadTasks();
      }
    }
  }

  /// Update an existing task
  Future<void> updateTask(TaskEntity task) async {
    try {
      await _repository.updateTask(task);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle subtask status
  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    final state = tasksSignal.value;
    if (state is AsyncData<List<TaskEntity>>) {
      final tasks = state.value;
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final task = tasks[taskIndex];
        final updatedSubtasks = task.subtasks.map((st) {
          return st.id == subtaskId ? st.copyWith(isDone: !st.isDone) : st;
        }).toList();

        await _repository.updateTask(task.copyWith(subtasks: updatedSubtasks));
        await loadTasks();
      }
    }
  }
}

// Support for Dot Shorthand and easy access
// In a real senior app, we might use a Service Locator or a global instance
// for features that need simple global access.
