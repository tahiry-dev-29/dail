import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';
import 'package:daily_os/features/planner/data/repositories/task_repository_impl.dart';
import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';

final taskLocalDataSourceProvider = Provider<ITaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource: localDataSource);
});

class TaskListNotifier extends Notifier<AsyncValue<List<TaskEntity>>> {
  @override
  AsyncValue<List<TaskEntity>> build() {
    // Initiate first load
    Future.microtask(() => loadTasks());
    return const AsyncValue.loading();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final tasks = await repository.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Alias for compatibility
  Future<void> getTasks() => loadTasks();

  Future<void> addTask({
    required String name,
    String description = '',
    required String time,
    DateTime? date,
    DateTime? deadline,
    bool isFavorite = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final task = TaskEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        time: time,
        date: date,
        deadline: deadline,
        isFavorite: isFavorite,
      );
      await repository.addTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleTask(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.toggleTask(id);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.deleteTask(id);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final currentTasks = await repository.getTasks();
      final taskIndex = currentTasks.indexWhere((t) => t.id == id);
      if (taskIndex != -1) {
        final updatedTask = currentTasks[taskIndex].copyWith(
          isFavorite: !currentTasks[taskIndex].isFavorite,
        );
        await repository.updateTask(updatedTask);
        await loadTasks();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleIgnore(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final currentTasks = await repository.getTasks();
      final taskIndex = currentTasks.indexWhere((t) => t.id == id);
      if (taskIndex != -1) {
        final updatedTask = currentTasks[taskIndex].copyWith(
          isIgnored: !currentTasks[taskIndex].isIgnored,
        );
        await repository.updateTask(updatedTask);
        await loadTasks();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addSubtask(
    String taskId, {
    required String name,
    String description = '',
    String time = '00:00',
    DateTime? deadline,
    bool isFavorite = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final currentTasks = await repository.getTasks();
      final taskIndex = currentTasks.indexWhere((t) => t.id == taskId);

      if (taskIndex != -1) {
        final task = currentTasks[taskIndex];
        final newSubtask = SubTaskEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          description: description,
          time: time,
          deadline: deadline,
          isFavorite: isFavorite,
        );
        final updatedTask = task.copyWith(
          subtasks: [...task.subtasks, newSubtask],
        );
        await repository.updateTask(updatedTask);
        await loadTasks();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final currentTasks = await repository.getTasks();
      final taskIndex = currentTasks.indexWhere((t) => t.id == taskId);

      if (taskIndex != -1) {
        final task = currentTasks[taskIndex];
        final updatedSubtasks = task.subtasks.map((st) {
          return st.id == subtaskId ? st.copyWith(isDone: !st.isDone) : st;
        }).toList();

        final updatedTask = task.copyWith(subtasks: updatedSubtasks);
        await repository.updateTask(updatedTask);
        await loadTasks();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteSubtask(String taskId, String subtaskId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final currentTasks = await repository.getTasks();
      final taskIndex = currentTasks.indexWhere((t) => t.id == taskId);

      if (taskIndex != -1) {
        final task = currentTasks[taskIndex];
        final updatedSubtasks = task.subtasks
            .where((st) => st.id != subtaskId)
            .toList();
        final updatedTask = task.copyWith(subtasks: updatedSubtasks);
        await repository.updateTask(updatedTask);
        await loadTasks();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.updateTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> demoteTask(
    String taskId, {
    required String targetParentId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final allTasks = await repository.getTasks();

      final taskIndex = allTasks.indexWhere((t) => t.id == taskId);
      final parentIndex = allTasks.indexWhere((t) => t.id == targetParentId);

      if (taskIndex == -1 || parentIndex == -1) return;

      final taskToDemote = allTasks[taskIndex];
      final parentTask = allTasks[parentIndex];

      // Create new subtask from task
      final newSubtask = SubTaskEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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

      await repository.updateTask(updatedParent);
      await repository.deleteTask(taskId);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTaskOrder(List<TaskEntity> orderedActiveTasks) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskRepositoryProvider);
      final allTasks = await repository.getTasks();

      final activeIds = orderedActiveTasks.map((t) => t.id).toSet();
      final otherTasks = allTasks
          .where((t) => !activeIds.contains(t.id))
          .toList();

      // New order: Ordered Active + Others
      final newTaskList = [...orderedActiveTasks, ...otherTasks];

      await repository.saveTasks(newTaskList);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final taskListProvider =
    NotifierProvider<TaskListNotifier, AsyncValue<List<TaskEntity>>>(
      TaskListNotifier.new,
    );
