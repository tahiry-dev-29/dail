import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskEditController {
  final TaskEntity initialTask;

  // ---------------------------------------------------------------------------
  // Core Data Signals (Mutable state for the form)
  // ---------------------------------------------------------------------------
  final Signal<String> name;
  final Signal<String> description;
  final Signal<String> time;
  final Signal<DateTime?> deadline;
  final Signal<bool> isFavorite;
  final Signal<bool> isDone;

  // Utilisation de ListSignal pour des mutations optimisées (add, removeAt...)
  final ListSignal<SubTaskEntity> subtasks;

  // ---------------------------------------------------------------------------
  // UI State Signals (View Logic)
  // ---------------------------------------------------------------------------
  final Signal<bool> isAddingSubtask = Signal(false);
  final Signal<String?> editingSubtaskId = Signal(null);
  // On initialise à false, on ouvrira si besoin dans le constructeur
  final Signal<bool> isDescriptionExpanded = Signal(false);
  final Signal<bool> isSubtasksExpanded = Signal(false);

  // ---------------------------------------------------------------------------
  // Constructor & Init
  // ---------------------------------------------------------------------------
  TaskEditController(this.initialTask)
    : name = Signal(initialTask.name),
      description = Signal(initialTask.description),
      time = Signal(initialTask.time),
      deadline = Signal(initialTask.deadline),
      isFavorite = Signal(initialTask.isFavorite),
      isDone = Signal(initialTask.isDone),
      subtasks = ListSignal([...initialTask.subtasks]) {
    // Auto-expand logic based on content
    if (initialTask.description.isNotEmpty) {
      isDescriptionExpanded.value = true;
    }
    if (initialTask.subtasks.isNotEmpty) {
      isSubtasksExpanded.value = true;
    }
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void toggleDone() => isDone.value = !isDone.value;

  void toggleAddingSubtask() {
    isAddingSubtask.value = !isAddingSubtask.value;
    if (isAddingSubtask.value) {
      editingSubtaskId.value = null; // Ferme l'édition si on ajoute
      isSubtasksExpanded.value = true; // Force l'ouverture
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
    if (name.isEmpty) return;

    final newSubtask = SubTaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      time: time,
      deadline: deadline,
      isFavorite: isFavorite,
      isDone: false,
    );

    // La magie de ListSignal : pas besoin de cloner la liste
    subtasks.add(newSubtask);

    // Reset UI state
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
    // Modification directe via l'index (optimisé par ListSignal)
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

  /// Promeut une sous-tâche en tâche principale
  void promoteSubtask(String id, WidgetRef ref) {
    final index = subtasks.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final subtask = subtasks[index];
    deleteSubtask(id); // Retire de la liste locale

    // Ajoute à la liste globale via le provider parent
    ref
        .read(taskListProvider.notifier)
        .addTask(
          name: subtask.name,
          description: subtask.description,
          time: subtask.time,
          date: initialTask.date ?? DateTime.now(), // Garde la date du parent
          deadline: subtask.deadline,
          isFavorite: subtask.isFavorite,
        );
  }

  /// Sauvegarde finale
  void save(WidgetRef ref) {
    final updatedTask = initialTask.copyWith(
      name: name.value,
      description: description.value,
      time: time.value,
      deadline: deadline.value,
      isFavorite: isFavorite.value,
      isDone: isDone.value,
      subtasks: subtasks.toList(), // Conversion ListSignal -> List
    );

    ref.read(taskListProvider.notifier).updateTask(updatedTask);
  }
}

// Le Provider unique
final taskEditControllerProvider = Provider.autoDispose
    .family<TaskEditController, TaskEntity>((ref, task) {
      return TaskEditController(task);
    });
