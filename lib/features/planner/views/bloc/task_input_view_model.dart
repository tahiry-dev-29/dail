import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

// ============================================================================
// GLOBAL DRAFT SIGNALS - Persis task input data even when widget closes
// ============================================================================
final taskDraftSignal = signal<Map<String, dynamic>>({});
final parentTaskSignal = signal<TaskEntity?>(null);
// final isAddTaskVisible = signal(false);

/// Save current form state to draft
void saveDraft({
  required String name,
  required String description,
  required String? time,
  required DateTime? deadline,
  required bool isFavorite,
  required List<String> tagIds,
  required String? workspaceId,
}) {
  taskDraftSignal.value = {
    'name': name,
    'description': description,
    'time': time,
    'deadline': deadline,
    'isFavorite': isFavorite,
    'tagIds': tagIds,
    'workspaceId': workspaceId,
  };
}

/// Clear draft after successful save
void clearDraft() {
  taskDraftSignal.value = {};
  parentTaskSignal.value = null;
}

/// Check if there's an active draft
bool hasDraft() => taskDraftSignal.value.isNotEmpty;

class TaskInputViewModel {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final focusNode = FocusNode();

  // UI Signals
  final isDescriptionExpanded = signal(false);
  final isFavorite = signal(false);
  final time = signal<String?>(null);
  final deadline = signal<DateTime?>(null);
  final tagIds = listSignal<String>([]);
  final workspaceId = signal<String?>(null);

  TaskInputViewModel(Map<String, dynamic> initialData) {
    // Merge draft data with initial data (draft takes priority for name/description)
    final draft = taskDraftSignal.peek();
    final mergedData = <String, dynamic>{
      ...initialData,
      if (draft['name']?.toString().isNotEmpty == true) 'name': draft['name'],
      if (draft['description']?.toString().isNotEmpty == true)
        'description': draft['description'],
      if (draft['time'] != null) 'time': draft['time'],
      if (draft['deadline'] != null) 'deadline': draft['deadline'],
      if (draft['isFavorite'] == true) 'isFavorite': draft['isFavorite'],
      if (draft['tagIds'] != null) 'tagIds': draft['tagIds'],
      if (draft['workspaceId'] != null) 'workspaceId': draft['workspaceId'],
    };

    nameController.text = mergedData['name'] ?? '';
    descController.text = mergedData['description'] ?? '';
    isFavorite.value = mergedData['isFavorite'] ?? false;
    time.value = mergedData['time'];
    deadline.value = mergedData['deadline'];
    tagIds.value = List<String>.from(mergedData['tagIds'] ?? []);
    workspaceId.value = mergedData['workspaceId'];

    if (descController.text.isNotEmpty) isDescriptionExpanded.value = true;

    // Delay focus to ensure widget is mounted
    Future.microtask(() => focusNode.requestFocus());

    // Auto-save on text changes
    nameController.addListener(_onContentChanged);
    descController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    saveDraft(
      name: nameController.text,
      description: descController.text,
      time: time.peek(),
      deadline: deadline.peek(),
      isFavorite: isFavorite.peek(),
      tagIds: tagIds.peek(),
      workspaceId: workspaceId.peek(),
    );
  }

  /// Reset form state and clear draft
  void reset() {
    // Stop listening to prevent saving empty draft during reset
    nameController.removeListener(_onContentChanged);
    descController.removeListener(_onContentChanged);

    nameController.clear();
    descController.clear();
    isFavorite.value = false;
    time.value = null;
    deadline.value = null;
    tagIds.clear();
    workspaceId.value = null;
    isDescriptionExpanded.value = false;

    clearDraft();

    // Re-attach listeners
    nameController.addListener(_onContentChanged);
    descController.addListener(_onContentChanged);

    // Keep focus on name input for rapid entry
    focusNode.requestFocus();
  }

  void dispose() {
    // Only save as draft if there's actual content
    if (nameController.text.trim().isNotEmpty ||
        descController.text.trim().isNotEmpty) {
      saveDraft(
        name: nameController.text,
        description: descController.text,
        time: time.peek(),
        deadline: deadline.peek(),
        isFavorite: isFavorite.peek(),
        tagIds: tagIds.peek(),
        workspaceId: workspaceId.peek(),
      );
    }

    nameController.removeListener(_onContentChanged);
    descController.removeListener(_onContentChanged);
    nameController.dispose();
    descController.dispose();
    focusNode.dispose();
  }
}
