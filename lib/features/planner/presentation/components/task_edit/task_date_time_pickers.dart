import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/picker_card.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskDateTimePickers extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;

  const TaskDateTimePickers({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final time = viewModel.time.watch(context);
    final deadline = viewModel.deadline.watch(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          // Time Picker
          PickerCard(
            label: 'TIME',
            value: time.isEmpty ? 'Set time' : time,
            icon: AppIcons.clock(context),
            color: Colors.blueAccent,
            onTap: () async {
              final tod = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (tod != null && context.mounted) {
                viewModel.time.value = tod.format(context);
              }
            },
          ),

          const SizedBox(width: 16),

          // Deadline Picker
          PickerCard(
            label: 'DEADLINE',
            value: deadline == null
                ? 'No deadline'
                : DateFormat('MMM d, HH:mm').format(deadline),
            icon: AppIcons.calendar(context),
            color: Colors.orangeAccent,
            onTap: () => _handleDeadlineSelection(context),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeadlineSelection(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !context.mounted) return;

    viewModel.deadline.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}
