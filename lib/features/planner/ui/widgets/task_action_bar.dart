import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../providers/task_edit_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/theme/adaptive_colors.dart';

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
    controller.isDone.watch(context);
    final isDoneValue = controller.isDone.value;
    final colors = context.colors;

    // Use current accent color
    final accent = colors.accent;
    final buttonBg = accent.withValues(alpha: 0.15);

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
          color: buttonBg,
          child: Text(
            isDoneValue ? 'Mark uncompleted' : 'Mark completed',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
