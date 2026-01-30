import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/features/planner/presentation/providers/task_list_provider.dart';
import 'package:daily_os/features/planner/providers/task_input_provider.dart';
import 'package:daily_os/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';

// Signal to control visibility of add task input
final isAddTaskVisible = signal(false);

class AddTaskInline extends ConsumerWidget {
  const AddTaskInline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = isAddTaskVisible.watch(context);
    final parentTask = parentTaskSignal.watch(context);

    if (!isVisible) return const SizedBox.shrink();

    final selectedDate = calendarState.selectedDate.value;

    void onSave({
      required String name,
      required String description,
      String? time,
      DateTime? deadline,
      required bool isFavorite,
    }) {
      if (parentTask != null) {
        // Adding a subtask
        ref
            .read(taskListProvider.notifier)
            .addSubtask(
              parentTask.id,
              name: name,
              description: description,
              time: time ?? '00:00',
              deadline: deadline,
              isFavorite: isFavorite,
            );
      } else {
        // Adding a regular task
        ref
            .read(taskListProvider.notifier)
            .addTask(
              name: name,
              description: description,
              time: time ?? '00:00',
              date: selectedDate,
              deadline: deadline,
              isFavorite: isFavorite,
            );
      }

      // Clear draft on successful save
      clearDraft();
      isAddTaskVisible.value = false;

      ToastService.success(
        context,
        parentTask != null ? '✨ Sous-tâche ajoutée' : '✨ Tâche ajoutée',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TaskInputWidget(
        onSave: onSave,
        onCancel: () {
          isAddTaskVisible.value = false;
          parentTaskSignal.value = null;
        },
        initialValues: {
          'name': parentTask != null ? '' : null, // Clear if switching context
        },
        hintText: parentTask != null
            ? 'Sous-tâche pour "${parentTask.name}"...'
            : 'Ajouter une tâche...',
      ),
    );
  }
}
