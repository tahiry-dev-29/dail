import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

final taskInputProvider = Provider.autoDispose
    .family<TaskInputState, Map<String, dynamic>>((ref, initialData) {
      final state = TaskInputState(initialData);
      // Automatic disposal of controllers and focus nodes
      ref.onDispose(() => state.dispose());
      return state;
    });

class TaskInputState {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final focusNode = FocusNode();

  // UI Signals
  final isDescriptionExpanded = signal(false);
  final isFavorite = signal(false);
  final time = signal('00:00');
  final deadline = signal<DateTime?>(null);

  TaskInputState(Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    descController.text = data['description'] ?? '';
    isFavorite.value = data['isFavorite'] ?? false;
    time.value = data['time'] ?? '00:00';
    deadline.value = data['deadline'];

    if (descController.text.isNotEmpty) isDescriptionExpanded.value = true;
    focusNode.requestFocus();
  }

  void dispose() {
    nameController.dispose();
    descController.dispose();
    focusNode.dispose();
  }
}
