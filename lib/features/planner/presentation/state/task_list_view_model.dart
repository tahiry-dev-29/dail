import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/add_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/delete_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/reorder_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/toggle_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/update_task_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskListViewModel {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ToggleTaskUseCase _toggleTaskUseCase;
  final ReorderTasksUseCase _reorderTasksUseCase;

  TaskListViewModel({
    required GetTasksUseCase getTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskUseCase toggleTaskUseCase,
    required ReorderTasksUseCase reorderTasksUseCase,
    required CalendarViewModel calendarVM,
  }) : _getTasksUseCase = getTasksUseCase,
       _addTaskUseCase = addTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _toggleTaskUseCase = toggleTaskUseCase,
       _reorderTasksUseCase = reorderTasksUseCase,
       _calendarVM = calendarVM;

  final CalendarViewModel _calendarVM;

  final tasks = signal<AsyncState<List<TaskEntity>>>(const AsyncLoading());

  // Filtering state
  final searchQuery = signal('');
  final selectedTagIds = listSignal<String>([]);
  final selectedWorkspaceId = signal<String?>(null);

  late final filteredTasks = computed<AsyncState<List<TaskEntity>>>(() {
    final state = tasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return state;

    final allTasks = state.value;
    final query = searchQuery.value.toLowerCase();
    final tags = selectedTagIds.value;
    final workspace = selectedWorkspaceId.value;
    final date = _calendarVM.selectedDate.value;

    final filtered = allTasks.where((task) {
      // Date filter (Keep tasks with no date OR matching selected date)
      final taskDate = task.date;
      final matchesDate =
          taskDate == null ||
          (taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day);

      if (!matchesDate) return false;

      // Search filter
      if (query.isNotEmpty && !task.name.toLowerCase().contains(query)) {
        return false;
      }

      // Tags filter (OR logic: task has at least one of the selected tags)
      if (tags.isNotEmpty) {
        if (task.tagIds.isEmpty) return false;
        if (!tags.any((id) => task.tagIds.contains(id))) return false;
      }

      // Workspace filter
      if (workspace != null && task.workspaceId != workspace) {
        return false;
      }

      return true;
    }).toList();

    return AsyncData(filtered);
  });

  Future<void> loadTasks() async {
    tasks.value = const AsyncLoading();
    try {
      final result = await _getTasksUseCase();
      tasks.value = AsyncData(result);
    } catch (e, stack) {
      tasks.value = AsyncError(e, stack);
    }
  }

  Future<void> addTask({
    required String name,
    String description = '',
    required String time,
    DateTime? date,
    DateTime? deadline,
    bool isFavorite = false,
    List<String> tagIds = const [],
    String? workspaceId,
  }) async {
    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      time: time,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
      tagIds: tagIds,
      workspaceId: workspaceId,
    );
    try {
      await _addTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      // Handle error (e.g., show notification)
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      await _updateTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _deleteTaskUseCase(id);
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      await _toggleTaskUseCase(id);
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> reorderTasks(List<TaskEntity> orderedTasks) async {
    try {
      await _reorderTasksUseCase(orderedTasks);
      // We don't necessarily need to reload if we trust the order we sent,
      // but reloading ensures consistency with the database.
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }
}
