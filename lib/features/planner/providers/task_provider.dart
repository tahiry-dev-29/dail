import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../data/subtask_model.dart';

class TaskNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    // Initial data cleared as requested
    return [];
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
    // Standard: Append to list, do not force sort to respect manual ordering
    state = [...state, newTask];
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
        if (task.id == updatedTask.id)
          // Logic refinement: Only un-ignore if the new date is Today or Future
          (task.isIgnored &&
                  updatedTask.date != null &&
                  !updatedTask.date!.isBefore(
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                  ))
              ? updatedTask.copyWith(isIgnored: false)
              : updatedTask
        else
          task,
    ];
  }

  // Precise reordering: Accepts the exact ordered list from UI to prevent index mismatches
  // caused by filtering (e.g. overdue tasks hidden in UI but present in state).
  void updateTaskOrder(List<Task> orderedSubset) {
    final subsetIds = orderedSubset.map((t) => t.id).toSet();

    // Keep 'others' (tasks not in the subset)
    final others = state.where((t) => !subsetIds.contains(t.id)).toList();

    // New state = Ordered Active Tasks + Others
    // This prioritizes the user's manual sort of the active list.
    state = [...orderedSubset, ...others];
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
    final items = [...state];
    items.removeAt(index);

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
