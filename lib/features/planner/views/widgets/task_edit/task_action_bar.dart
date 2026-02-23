import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/views/bloc/task_edit_view_model.dart';
import 'package:flutter/material.dart';

class TaskActionBar extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;
  final VoidCallback? onBack;

  const TaskActionBar({
    super.key,
    required this.viewModel,
    required this.onSave,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.centerRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            onSave();
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          child: GlassCard(
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            color: context.colors.accent,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
