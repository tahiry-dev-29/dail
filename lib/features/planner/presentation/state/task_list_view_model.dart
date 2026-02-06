import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/add_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/delete_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/reorder_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/toggle_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/update_task_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class TaskListViewModel {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ToggleTaskUseCase _toggleTaskUseCase;
  final ReorderTasksUseCase _reorderTasksUseCase;
  final WorkspaceViewModel _workspaceVM;
  final CalendarViewModel _calendarVM;

  TaskListViewModel({
    required GetTasksUseCase getTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskUseCase toggleTaskUseCase,
    required ReorderTasksUseCase reorderTasksUseCase,
    required WorkspaceViewModel workspaceVM,
    required CalendarViewModel calendarVM,
  }) : _getTasksUseCase = getTasksUseCase,
       _addTaskUseCase = addTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _toggleTaskUseCase = toggleTaskUseCase,
       _reorderTasksUseCase = reorderTasksUseCase,
       _workspaceVM = workspaceVM,
       _calendarVM = calendarVM;

  final tasks = signal<AsyncState<List<TaskEntity>>>(const AsyncLoading());

  // Filtering state
  final searchQuery = signal('');
  final selectedTagIds = listSignal<String>([]);
  final selectedWorkspaceId = signal<String?>(null);
  final selectedFolderId = signal<String?>(null);

  late final filteredTasks = computed<AsyncState<List<TaskEntity>>>(() {
    final state = tasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return state;

    final allTasks = state.value;
    final query = searchQuery.value.toLowerCase();
    final tags = selectedTagIds.value;
    final activeWorkspace = _workspaceVM.activeWorkspace.value;
    final folder = selectedFolderId.value;
    final date = _calendarVM.selectedDate.value;

    final filtered = allTasks.where((task) {
      // Workspace filter (Global context)
      if (activeWorkspace != null) {
        final taskWsId = task.workspaceId;
        final activeWsId = activeWorkspace.id;

        // Match if IDs match, or if both are "default/null" equivalents
        final isDefaultMatch =
            (activeWsId == 'default' && (taskWsId == null || taskWsId.isEmpty));
        if (taskWsId != activeWsId && !isDefaultMatch) {
          return false;
        }
      }

      // Folder filter
      if (folder != null && task.folderId != folder) return false;

      // Date filter: SKIP when a folder is explicitly selected (folder view shows ALL tasks)
      if (folder == null) {
        final taskDate = task.date;
        final matchesDate =
            taskDate == null ||
            (taskDate.year == date.year &&
                taskDate.month == date.month &&
                taskDate.day == date.day);

        if (!matchesDate) return false;
      }

      // Search filter
      if (query.isNotEmpty && !task.name.toLowerCase().contains(query)) {
        return false;
      }

      // Tags filter
      if (tags.isNotEmpty) {
        if (task.tagIds.isEmpty) return false;
        if (!tags.any((id) => task.tagIds.contains(id))) return false;
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
    String? folderId,
    String iconEmoji = '📝',
  }) async {
    final task = TaskEntity(
      id: Uuid().v4(),
      name: name,
      description: description,
      time: time,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
      tagIds: tagIds,
      workspaceId: workspaceId ?? _workspaceVM.activeWorkspace.value?.id,
      folderId: folderId ?? selectedFolderId.value,
      iconEmoji: iconEmoji,
    );
    try {
      await _addTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      // Handle error
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
      await loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  void selectFolder(String? folderId) {
    selectedFolderId.value = folderId;
    // Clearing search and tags to avoid empty states in the new folder view
    searchQuery.value = '';
    selectedTagIds.value = [];
    selectedWorkspaceId.value = null;

    // Reset date to today when explicitly browsing a folder to avoid empty views
    // if the previous date filter (e.g. from calendar) doesn't have tasks in this folder.
    _calendarVM.selectedDate.value = DateTime.now();
  }
}
