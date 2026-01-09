import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../providers/task_edit_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskActionBar extends StatelessWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const TaskActionBar({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = controller.isDone.watch(context);

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          controller.toggleDone();
          onSave();
          Navigator.pop(context);
        },
        child: GlassContainer(
          borderRadius: 30,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.blueAccent.withValues(alpha: 0.2),
          child: Text(
            isDone ? 'Mark uncompleted' : 'Mark completed',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
