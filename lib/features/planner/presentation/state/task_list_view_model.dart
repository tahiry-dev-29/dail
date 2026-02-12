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

  // UI State
  final isSearching = signal(false);

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
      // 1. Workspace filter
      // If no active workspace is selected, show ALL tasks
      // If 'default' is selected, show tasks with 'default', null, or empty workspaceId
      if (activeWorkspace != null) {
        final taskWsId = task.workspaceId;
        final activeWsId = activeWorkspace.id;

        if (activeWsId != 'default') {
          // Strict match for non-default workspaces
          if (taskWsId != activeWsId) return false;
        } else {
          // Permissive match for default workspace
          final isTaskDefault =
              taskWsId == null || taskWsId.isEmpty || taskWsId == 'default';
          if (!isTaskDefault) return false;
        }
      }

      // 2. Folder filter
      if (folder != null && task.folderId != folder) return false;

      // 3. Date filter: SKIP when a folder is explicitly selected (folder view shows ALL tasks)
      // Also show tasks with NO date on the dashboard.
      if (folder == null) {
        final taskDate = task.date;
        if (taskDate != null) {
          final isSameDay =
              taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
          if (!isSameDay) return false;
        }
        // tasks with taskDate == null are always shown in the dashboard (unscheduled)
      }

      // 4. Search and Tags
      if (query.isNotEmpty && !task.name.toLowerCase().contains(query)) {
        return false;
      }

      if (tags.isNotEmpty) {
        if (task.tagIds.isEmpty) return false;
        if (!tags.any((id) => task.tagIds.contains(id))) return false;
      }

      return true;
    }).toList();
    return AsyncData(filtered);
  });

  late final activeTasks = computed<AsyncState<List<TaskEntity>>>(() {
    final state = filteredTasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return state;

    final now = DateTime.now();
    final tasks = state.value.where((t) {
      return !t.isDone &&
          !t.isIgnored &&
          (t.deadline == null || t.deadline!.isAfter(now));
    }).toList();

    return AsyncData(tasks);
  });

  late final completedTasks = computed<AsyncState<List<TaskEntity>>>(() {
    final state = filteredTasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return state;

    final tasks = state.value.where((t) => t.isDone).toList();
    return AsyncData(tasks);
  });

  late final expiredTasks = computed<AsyncState<List<TaskEntity>>>(() {
    final state = filteredTasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return state;

    final now = DateTime.now();
    final tasks = state.value.where((t) {
      return !t.isDone && t.deadline != null && t.deadline!.isBefore(now);
    }).toList();
    return AsyncData(tasks);
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

  Future<void> toggleFavorite(String id) async {
    final state = tasks.value;
    if (state is! AsyncData<List<TaskEntity>>) return;

    final task = state.value.firstWhere((t) => t.id == id);
    try {
      await updateTask(task.copyWith(isFavorite: !task.isFavorite));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> reorderTasks(List<TaskEntity> orderedTasks) async {
    // 1. Optimistic Update: Update the signal immediately to keep UI smooth
    tasks.value = AsyncData(orderedTasks);

    try {
      await _reorderTasksUseCase(orderedTasks);
    } catch (e) {
      // In case of error, reload original state
      await loadTasks();
    }
  }

  void onReorderActiveTasks(int oldIndex, int newIndex) {
    // SliverReorderableList/ReorderableListView pass indices where if old < new, new is "after insertion" index.
    // Standard adjustment for list.insert:
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final activeState = activeTasks.value;
    final allState = filteredTasks.value;

    if (activeState is! AsyncData || allState is! AsyncData) return;

    final activeList = activeState.value!.toList();
    final allList = allState.value!.toList();

    // 1. Reorder active list locally
    final item = activeList.removeAt(oldIndex);
    activeList.insert(newIndex, item);

    // 2. Reconstruct full list by mapping slots of active tasks
    // We assume filteredTasks preserves the order of tasks.value
    final newFullList = <TaskEntity>[];
    int activeIndex = 0;
    final now = DateTime.now();

    for (final task in allList) {
      final isActive =
          !task.isDone &&
          !task.isIgnored &&
          (task.deadline == null || task.deadline!.isAfter(now));

      if (isActive) {
        if (activeIndex < activeList.length) {
          newFullList.add(activeList[activeIndex]);
          activeIndex++;
        }
      } else {
        newFullList.add(task);
      }
    }

    reorderTasks(newFullList);
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
