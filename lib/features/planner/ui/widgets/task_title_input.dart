import 'package:flutter/material.dart';
import '../../providers/task_edit_controller.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white24 : Colors.black26;

    // Use a key to ensure we don't lose focus/cursor state unnecessarily,
    // although controller logic here mimics previous state.
    // We recreate controller only if needed, but text field handles its own state mostly.

    return TextField(
      controller: TextEditingController(text: controller.name.peek())
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.name.peek().length),
        ),
      onChanged: (val) {
        controller.updateName(val);
        onSave();
      },
      style: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Task Title',
        hintStyle: TextStyle(color: hintColor),
      ),
    );
  }
}
