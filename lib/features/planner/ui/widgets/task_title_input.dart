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
    // Initial value for controller
    // We don't watch 'name' signal here for the TextField value itself
    // to avoid rebuilding the TextField while typing if not needed,
    // but we use TextEditingController initialized with signal value.
    // However, to keep it simple and consistent:

    return TextField(
      controller: TextEditingController(text: controller.name.peek())
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.name.peek().length),
        ), // Cursor at end
      onChanged: (val) {
        controller.updateName(val);
        onSave();
      },
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Task Title',
        hintStyle: TextStyle(color: Colors.white24),
      ),
    );
  }
}
