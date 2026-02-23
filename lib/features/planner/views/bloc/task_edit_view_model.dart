import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class TaskEditViewModel {
  final TaskEntity initialTask;
  final TaskListViewModel _taskListViewModel;

  // Form Fields
  final Signal<String> name;
  final Signal<String> description;
  final Signal<String> time;
  final Signal<DateTime?> deadline;
  final Signal<bool> isFavorite;
  final Signal<bool> isDone;
  final ListSignal<SubTaskEntity> subtasks;
  final Signal<String?> audioPath;
  final Signal<int?> audioDurationMs;

  // UI State
  final Signal<bool> isAddingSubtask = Signal(false);
  final Signal<String?> editingSubtaskId = Signal(null);
  final Signal<bool> isDescriptionExpanded = Signal(false);
  final Signal<bool> isSubtasksExpanded = Signal(false);
  final ListSignal<String> tagIds;
  final Signal<String?> workspaceId;

  TaskEditViewModel(this.initialTask, this._taskListViewModel)
    : name = Signal(initialTask.name),
      description = Signal(initialTask.description),
      time = Signal(initialTask.time),
      deadline = Signal(initialTask.deadline),
      isFavorite = Signal(initialTask.isFavorite),
      isDone = Signal(initialTask.isDone),
      subtasks = ListSignal([...initialTask.subtasks]),
      tagIds = ListSignal([...initialTask.tagIds]),
      workspaceId = Signal(initialTask.workspaceId),
      audioPath = Signal(initialTask.audioPath),
      audioDurationMs = Signal(initialTask.audioDurationMs) {
    if (initialTask.description.isNotEmpty) {
      isDescriptionExpanded.value = true;
    }
    if (initialTask.subtasks.isNotEmpty) {
      isSubtasksExpanded.value = true;
    }
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void toggleDone() => isDone.value = !isDone.value;

  void toggleAddingSubtask() {
    isAddingSubtask.value = !isAddingSubtask.value;
    if (isAddingSubtask.value) {
      editingSubtaskId.value = null;
      isSubtasksExpanded.value = true;
    }
  }

  void setEditingSubtask(String? id) {
    editingSubtaskId.value = id;
    if (id != null) {
      isAddingSubtask.value = false;
    }
  }

  void addSubtask({
    required String name,
    required String description,
    required String time,
    DateTime? deadline,
    bool isFavorite = false,
  }) {
    if (name.trim().isEmpty) return;

    final newSubtask = SubTaskEntity(
      id: Uuid().v4(),
      name: name,
      description: description,
      time: time,
      deadline: deadline,
      isFavorite: isFavorite,
      isDone: false,
    );

    subtasks.add(newSubtask);
    isAddingSubtask.value = false;
  }

  void updateSubtask(
    String id, {
    String? name,
    String? description,
    String? time,
    DateTime? deadline,
    bool? isFavorite,
  }) {
    final index = subtasks.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final current = subtasks[index];
    subtasks[index] = current.copyWith(
      name: name ?? current.name,
      description: description ?? current.description,
      time: time ?? current.time,
      deadline: deadline ?? current.deadline,
      isFavorite: isFavorite ?? current.isFavorite,
    );

    editingSubtaskId.value = null;
  }

  void toggleSubtaskDone(String id) {
    final index = subtasks.indexWhere((s) => s.id == id);
    if (index != -1) {
      subtasks[index] = subtasks[index].copyWith(
        isDone: !subtasks[index].isDone,
      );
    }
  }

  void deleteSubtask(String id) {
    subtasks.removeWhere((s) => s.id == id);
  }

  void reorderSubtasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = subtasks.removeAt(oldIndex);
    subtasks.insert(newIndex, item);
  }

  void promoteSubtask(String id) {
    final index = subtasks.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final subtask = subtasks[index];
    deleteSubtask(id); // Retire de la liste locale

    // Ajoute à la liste globale via le list view model
    _taskListViewModel.addTask(
      name: subtask.name,
      description: subtask.description,
      time: subtask.time,
      date: initialTask.date ?? DateTime.now(),
      deadline: subtask.deadline,
      isFavorite: subtask.isFavorite,
    );
  }

  /// Save changes back to TaskListViewModel
  void save() {
    final updatedTask = initialTask.copyWith(
      name: name.value,
      description: description.value,
      time: time.value,
      deadline: deadline.value,
      isFavorite: isFavorite.value,
      isDone: isDone.value,
      subtasks: subtasks.toList(),
      tagIds: tagIds.toList(),
      workspaceId: workspaceId.value,
      audioPath: audioPath.value,
      audioDurationMs: audioDurationMs.value,
    );

    _taskListViewModel.updateTask(updatedTask);
  }
}
