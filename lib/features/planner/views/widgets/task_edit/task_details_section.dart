import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/widgets/task_tag_picker.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/widgets/task_workspace_picker.dart';
import 'package:daily_os/features/planner/views/bloc/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;

  const TaskDetailsSection({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Watch signals
    final desc = viewModel.description.watch(context);
    final isExpanded = viewModel.isDescriptionExpanded.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => viewModel.isDescriptionExpanded.value = !isExpanded,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Text('DESCRIPTION', style: context.caption),
              const Spacer(),
              Icon(
                isExpanded
                    ? AppIcons.chevronUp(context)
                    : AppIcons.chevronDown(context),
                size: 14,
                color: context.colors.textMuted,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? GlassCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: TextEditingController(
                      text: desc,
                    )..selection = TextSelection.collapsed(offset: desc.length),
                    onChanged: (val) => viewModel.description.value = val,
                    style: context.bodyMedium,
                    maxLines: 4,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: 'Add details, notes, or links...',
                      hintStyle: TextStyle(color: context.colors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterStyle: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
        TaskWorkspacePicker(selectedWorkspaceId: viewModel.workspaceId),
        const SizedBox(height: 24),
        TaskTagPicker(selectedTagIds: viewModel.tagIds),
      ],
    );
  }
}
