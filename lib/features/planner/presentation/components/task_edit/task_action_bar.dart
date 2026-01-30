import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            onSave();
            Navigator.pop(context);
          },
          child: GlassCard(
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            color: context.colors.accent,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white, // Keep white on accent for contrast
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
