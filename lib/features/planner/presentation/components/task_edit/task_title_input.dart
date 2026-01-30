import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:flutter/material.dart';

class TaskTitleInput extends StatelessWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const TaskTitleInput({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Watch signal for initial value if needed, but TextController usually handles input
    // Only need careful sync if controller.name changes externally.
    // For simplicity, we can use a standard TextField that updates the signal on change.

    return TextField(
      controller: TextEditingController(text: controller.name.peek())
        ..selection = TextSelection.collapsed(
          offset: controller.name.peek().length,
        ),
      onChanged: (val) => controller.name.value = val,
      style: context.h1,
      decoration: InputDecoration(
        hintText: 'Task Name',
        hintStyle: TextStyle(color: context.colors.textMuted),
        border: InputBorder.none,
        counterStyle: TextStyle(color: context.colors.textMuted, fontSize: 10),
      ),
      maxLines: null,
      maxLength: 100,
    );
  }
}
