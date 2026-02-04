import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:flutter/material.dart';

class TaskTitleInput extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;

  const TaskTitleInput({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: viewModel.name.peek())
        ..selection = TextSelection.collapsed(
          offset: viewModel.name.peek().length,
        ),
      onChanged: (val) => viewModel.name.value = val,
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
