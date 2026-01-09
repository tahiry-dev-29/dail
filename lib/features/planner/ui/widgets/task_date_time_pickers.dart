import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_edit_controller.dart';

class TaskDateTimePickers extends StatelessWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const TaskDateTimePickers({
    super.key,
    required this.controller,
    required this.onSave,
  });

  Future<void> _pickDeadline(BuildContext context) async {
    final currentDeadline = controller.deadline.value ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: currentDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDeadline),
      );
      if (time != null && context.mounted) {
        controller.updateDeadline(
          DateTime(date.year, date.month, date.day, time.hour, time.minute),
        );
        onSave();
      }
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && context.mounted) {
      controller.updateTime(
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      );
      onSave();
    }
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Icon(
                icon,
                size: 18,
                color: isActive ? Colors.blueAccent : Colors.white60,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.blueAccent : Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deadline = controller.deadline.watch(context);
    final time = controller.time.watch(context);

    return Column(
      children: [
        _buildOptionItem(
          icon: FontAwesomeIcons.bullseye,
          label: deadline != null
              ? DateFormat('dd MMM, HH:mm').format(deadline)
              : 'Add deadline',
          isActive: deadline != null,
          onTap: () => _pickDeadline(context),
        ),
        _buildOptionItem(
          icon: FontAwesomeIcons.clock,
          label: time,
          isActive: true,
          onTap: () => _pickTime(context),
        ),
      ],
    );
  }
}
