import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:flutter/material.dart';

class SubtaskHeader extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final bool isAdding;
  final bool isExpanded;
  final Color accent;

  const SubtaskHeader({
    super.key,
    required this.viewModel,
    required this.isAdding,
    required this.isExpanded,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.isSubtasksExpanded.value = !isExpanded,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('SOUS-TÂCHES', style: context.caption),
          const Spacer(),
          if (!isAdding)
            IconButton(
              onPressed: viewModel.toggleAddingSubtask,
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
