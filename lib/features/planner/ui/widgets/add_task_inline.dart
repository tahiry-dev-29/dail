import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_provider.dart';
import '../../../calendar/providers/calendar_provider.dart';
import 'task_input_widget.dart';

// Signal to control visibility of add task input
final isAddTaskVisible = signal(false);

class AddTaskInline extends ConsumerWidget {
  const AddTaskInline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch signal
    final isVisible = isAddTaskVisible.watch(context);

    if (!isVisible) return const SizedBox.shrink();

    void onSave({
      required String name,
      required String description,
      required String time,
      DateTime? deadline,
      required bool isFavorite,
    }) {
      final selectedDate = calendarState.selectedDate.value;

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

      isAddTaskVisible.value = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TaskInputWidget(
        onSave: onSave,
        onCancel: () => isAddTaskVisible.value = false,
      ),
    );
  }
}
