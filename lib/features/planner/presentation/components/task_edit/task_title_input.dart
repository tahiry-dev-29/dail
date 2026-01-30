import 'package:flutter/material.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';

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
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        hintText: 'Task Name',
        hintStyle: TextStyle(color: Colors.white30),
        border: InputBorder.none,
        counterStyle: TextStyle(color: Colors.white30, fontSize: 10),
      ),
      maxLines: null,
      maxLength: 100,
    );
  }
}
