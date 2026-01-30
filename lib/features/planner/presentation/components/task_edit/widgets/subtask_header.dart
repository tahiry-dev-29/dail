import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:flutter/material.dart';

class SubtaskHeader extends StatelessWidget {
  final TaskEditController controller;
  final bool isAdding;
  final bool isExpanded;
  final Color accent;

  const SubtaskHeader({
    super.key,
    required this.controller,
    required this.isAdding,
    required this.isExpanded,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.isSubtasksExpanded.value = !isExpanded,
      behavior: .opaque,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text('SOUS-TÂCHES', style: context.caption),
          const Spacer(),
          if (!isAdding)
            IconButton(
              onPressed: controller.toggleAddingSubtask,
              icon: Icon(Icons.add, size: 20, color: accent),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          const SizedBox(width: 12),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 16,
            color: context.colors.textMuted,
          ),
        ],
      ),
    );
  }
}
