import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';

// ============================================================================
// DRAFT SIGNAL - Persists task input data even when widget closes
// ============================================================================
final taskDraftSignal = signal<Map<String, dynamic>>({});
final parentTaskSignal = signal<TaskEntity?>(null);

/// Save current form state to draft
void saveDraft({
  required String name,
  required String description,
  required String? time,
  required DateTime? deadline,
  required bool isFavorite,
}) {
  taskDraftSignal.value = {
    'name': name,
    'description': description,
    'time': time,
    'deadline': deadline,
    'isFavorite': isFavorite,
  };
}

/// Clear draft after successful save
void clearDraft() {
  taskDraftSignal.value = {};
  parentTaskSignal.value = null;
}

/// Check if there's an active draft
bool hasDraft() => taskDraftSignal.value.isNotEmpty;

// ============================================================================
// TASK INPUT PROVIDER
// ============================================================================
final taskInputProvider = Provider.autoDispose
    .family<TaskInputState, Map<String, dynamic>>((ref, initialData) {
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
      };

      final state = TaskInputState(mergedData);

      // Auto-save on dispose (when widget closes unexpectedly)
      ref.onDispose(() {
        // Only save as draft if there's actual content
        if (state.nameController.text.trim().isNotEmpty ||
            state.descController.text.trim().isNotEmpty) {
          saveDraft(
            name: state.nameController.text,
            description: state.descController.text,
            time: state.time.peek(),
            deadline: state.deadline.peek(),
            isFavorite: state.isFavorite.peek(),
          );
        }
        state.dispose();
      });

      return state;
    });

class TaskInputState {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final focusNode = FocusNode();

  // UI Signals
  final isDescriptionExpanded = signal(false);
  final isFavorite = signal(false);
  final time = signal<String?>(null);
  final deadline = signal<DateTime?>(null);

  TaskInputState(Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    descController.text = data['description'] ?? '';
    isFavorite.value = data['isFavorite'] ?? false;
    time.value = data['time'];
    deadline.value = data['deadline'];

    if (descController.text.isNotEmpty) isDescriptionExpanded.value = true;

    // Delay focus to ensure widget is mounted
    Future.microtask(() => focusNode.requestFocus());

    // Auto-save on text changes
    nameController.addListener(_onContentChanged);
    descController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    // Debounced auto-save could be added here for performance
    saveDraft(
      name: nameController.text,
      description: descController.text,
      time: time.peek(),
      deadline: deadline.peek(),
      isFavorite: isFavorite.peek(),
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
    isDescriptionExpanded.value = false;

    clearDraft();

    // Re-attach listeners
    nameController.addListener(_onContentChanged);
    descController.addListener(_onContentChanged);

    // Keep focus on name input for rapid entry
    focusNode.requestFocus();
  }

  void dispose() {
    nameController.removeListener(_onContentChanged);
    descController.removeListener(_onContentChanged);
    nameController.dispose();
    descController.dispose();
    focusNode.dispose();
  }
}
