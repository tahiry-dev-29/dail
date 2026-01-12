import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../data/task_model.dart';
import '../data/subtask_model.dart';
import '../providers/task_provider.dart';

class TaskEditController {
  final Task initialTask;

  // Core Data Signals
  final name = signal('');
  final description = signal('');
  final time = signal('00:00');
  final deadline = signal<DateTime?>(null);
  final isFavorite = signal(false);
  final isDone = signal(false);
  final subtasks = signal<List<SubTask>>([]);

  // UI State Signals
  final isDetailsExpanded = signal(false);
  final isSubtasksExpanded = signal(false);
  final isAddingSubtask = signal(false);
  final editingSubtaskId = signal<String?>(null);

  TaskEditController(this.initialTask) {
    name.value = initialTask.name;
    description.value = initialTask.description;
    time.value = initialTask.time;
    deadline.value = initialTask.deadline;
    isFavorite.value = initialTask.isFavorite;
    isDone.value = initialTask.isDone;
    subtasks.value = [...initialTask.subtasks];

    if (initialTask.description.isNotEmpty) isDetailsExpanded.value = true;
    if (initialTask.subtasks.isNotEmpty) isSubtasksExpanded.value = true;
  }

  void updateName(String val) => name.value = val;
  void updateDescription(String val) => description.value = val;
  void updateTime(String val) => time.value = val;
  void updateDeadline(DateTime? val) => deadline.value = val;
  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void toggleDone() => isDone.value = !isDone.value;

  // Dictionary-style updates for UI sections
  void toggleDetails() => isDetailsExpanded.value = !isDetailsExpanded.value;
  void toggleSubtasks() => isSubtasksExpanded.value = !isSubtasksExpanded.value;
  void toggleAddingSubtask() => isAddingSubtask.value = !isAddingSubtask.value;
  void setEditingSubtask(String? id) => editingSubtaskId.value = id;

  // Subtask Management
  void addSubtask({
    required String name,
    required String description,
    required String time,
    DateTime? deadline,
    required bool isFavorite,
  }) {
    final newSubtask = SubTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      time: time,
      deadline: deadline,
      isFavorite: isFavorite,
    );
    subtasks.value = [...subtasks.value, newSubtask];
    // Auto expand
    isSubtasksExpanded.value = true;
    isAddingSubtask.value = false;
  }

  void updateSubtask(
    String id, {
    required String name,
    required String description,
    required String time,
    DateTime? deadline,
    required bool isFavorite,
  }) {
    subtasks.value = subtasks.value.map((s) {
      if (s.id == id) {
        return s.copyWith(
          name: name,
          description: description,
          time: time,
          deadline: deadline,
          isFavorite: isFavorite,
        );
      }
      return s;
    }).toList();
    editingSubtaskId.value = null;
  }

  void toggleSubtaskDone(String id) {
    subtasks.value = subtasks.value.map((s) {
      if (s.id == id) {
        return s.copyWith(isDone: !s.isDone);
      }
      return s;
    }).toList();
  }

  void deleteSubtask(String id) {
    subtasks.value = subtasks.value.where((s) => s.id != id).toList();
  }

  void reorderSubtasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = [...subtasks.value];
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    subtasks.value = items;
  }

  void promoteSubtask(String id, WidgetRef ref) {
    final subtask = subtasks.value.firstWhere((s) => s.id == id);
    deleteSubtask(id);
    // Add to global tasks
    ref
        .read(taskProvider.notifier)
        .addTask(
          name: subtask.name,
          description: subtask.description,
          time: subtask.time,
          date: initialTask.date, // inherit date
          deadline: subtask.deadline,
          isFavorite: subtask.isFavorite,
        );
  }

  void save(WidgetRef ref) {
    final updatedTask = initialTask.copyWith(
      name: name.value,
      description: description.value,
      time: time.value,
      deadline: deadline.value,
      isFavorite: isFavorite.value,
      isDone: isDone.value,
      subtasks: subtasks.value,
    );
    ref.read(taskProvider.notifier).updateTask(updatedTask);
  }
}

final taskEditControllerProvider = Provider.autoDispose
    .family<TaskEditController, Task>((ref, task) {
      return TaskEditController(task);
    });
