import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

// Note: This component is being phased out in favor of QuickAddTaskOverlay
class AddTaskInline extends StatelessWidget {
  const AddTaskInline({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isVisible = isAddTaskVisible.value;
      final parentTask = parentTaskSignal.value;

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
          plannerController.addSubtask(parentTask.id, name);
        } else {
          plannerController.addTask(
            name: name,
            description: description,
            time: time ?? '00:00',
            date: selectedDate,
            deadline: deadline,
            isFavorite: isFavorite,
          );
        }

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
          initialValues: {'name': parentTask != null ? '' : null},
          hintText: parentTask != null
              ? 'Sous-tâche pour "${parentTask.name}"...'
              : 'Ajouter une tâche...',
        ),
      );
    });
  }
}
