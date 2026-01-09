import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_input_provider.dart';

class TaskInputActions extends StatelessWidget {
  final TaskInputState state;

  const TaskInputActions({super.key, required this.state});

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && context.mounted) {
      state.time.value =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && context.mounted) {
        state.deadline.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    String? label,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive
                ? (activeColor ?? Colors.blueAccent)
                : Colors.white38,
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: activeColor ?? Colors.blueAccent,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = state.time.watch(context);
    final selectedDeadline = state.deadline.watch(context);
    final fav = state.isFavorite.watch(context);
    final isDescExpanded = state.isDescriptionExpanded.watch(context);
    // Note: description signal logic might not be directly available in state if not passed,
    // but originally it was in controller. Here we rely on isDescriptionExpanded.

    // time is "00:00" if unset in controller
    final hasTime = selectedTime != '00:00';

    return Row(
      children: [
        // Description toggle
        _buildIconButton(
          icon: FontAwesomeIcons.bars,
          isActive: isDescExpanded,
          onTap: () => state.isDescriptionExpanded.value =
              !state.isDescriptionExpanded.value,
        ),
        const SizedBox(width: 16),
        // Time
        _buildIconButton(
          icon: FontAwesomeIcons.clock,
          isActive: hasTime,
          label: hasTime ? selectedTime : null,
          onTap: () => _pickTime(context),
        ),
        const SizedBox(width: 16),
        // Deadline
        _buildIconButton(
          icon: FontAwesomeIcons.calendarCheck,
          isActive: selectedDeadline != null,
          label: selectedDeadline != null
              ? DateFormat('dd/MM').format(selectedDeadline)
              : null,
          onTap: () => _pickDeadline(context),
        ),
        const SizedBox(width: 16),
        // Favorite
        _buildIconButton(
          icon: fav ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
          isActive: fav,
          activeColor: Colors.amber,
          onTap: () => state.isFavorite.value = !state.isFavorite.value,
        ),
      ],
    );
  }
}
