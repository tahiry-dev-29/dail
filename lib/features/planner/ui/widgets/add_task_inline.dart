import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_provider.dart';
import '../../providers/task_input_provider.dart';
import '../../services/time_slot_service.dart';
import '../../../calendar/providers/calendar_provider.dart';
import '../../../../shared/utils/toast_service.dart';
import 'task_input_widget.dart';

// Signal to control visibility of add task input
final isAddTaskVisible = signal(false);

class AddTaskInline extends ConsumerWidget {
  const AddTaskInline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = isAddTaskVisible.watch(context);

    if (!isVisible) return const SizedBox.shrink();

    // Reset logic is handled by TaskInputWidget or parent controller
    // Here we provide the initial time

    // User Request: "l heur actuel"
    final defaultTime = TimeSlotService.getCurrentTime();
    final selectedDate = calendarState.selectedDate.value;

    void onSave({
      required String name,
      required String description,
      required String time,
      DateTime? deadline,
      required bool isFavorite,
    }) {
      ref
          .read(taskProvider.notifier)
          .addTask(
            name: name,
            description: description,
            time: time,
            date: selectedDate,
            deadline: deadline,
            isFavorite: isFavorite,
          );

      // Clear draft on successful save
      clearDraft();

      // Keep form open or reset? User said "on submit + on reset"
      // Usually keeping it open is better for rapid entry, but let's close it as per current flow logic
      // or we can implement "Add & Continue" later.
      // For now, consistent behavior: Close inline, but reset is implicit because next time it opens, it recalculates 'defaultTime'
      isAddTaskVisible.value = false;

      ToastService.success(context, '✨ Tâche ajoutée');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TaskInputWidget(
        onSave: onSave,
        onCancel: () {
          // Don't clear draft on cancel - data persists
          isAddTaskVisible.value = false;
        },
        initialValues: {'time': defaultTime},
      ),
    );
  }
}
