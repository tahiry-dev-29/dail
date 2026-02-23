import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/views/bloc/task_edit_view_model.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/widgets/subtask_empty_state.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/widgets/subtask_header.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/widgets/subtask_item_tile.dart';
import 'package:daily_os/features/planner/views/widgets/task_form/task_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SubtaskListManager extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;

  const SubtaskListManager({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final subtasks = viewModel.subtasks.watch(context);
    final isAdding = viewModel.isAddingSubtask.watch(context);
    final isExpanded = viewModel.isSubtasksExpanded.watch(context);
    final editingId = viewModel.editingSubtaskId.watch(context);
    final colors = context.colors;
    final accent = colors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtaskHeader(
          viewModel: viewModel,
          isAdding: isAdding,
          isExpanded: isExpanded,
          accent: accent,
        ),
        const SizedBox(height: 12),

        // List Content
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(
                  children: [
                    if (subtasks.isNotEmpty) const SizedBox(height: 8),
                    // Standard ListView - no drag and drop
                    // Reorderable list for subtasks
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subtasks.length,
                      onReorder: (oldIndex, newIndex) {
                        viewModel.reorderSubtasks(oldIndex, newIndex);
                        onSave();
                      },
                      itemBuilder: (context, index) {
                        final subtask = subtasks[index];
                        return SubtaskItemTile(
                          key: ValueKey(subtask.id),
                          st: subtask,
                          index: index,
                          isEditing: editingId == subtask.id,
                          viewModel: viewModel,
                          onSave: onSave,
                        );
                      },
                    ),

                    // Add Input
                    if (isAdding)
                      _SubtaskAddInput(viewModel: viewModel, onSave: onSave)
                    else if (subtasks.isEmpty)
                      SubtaskEmptyState(
                        onPressed: viewModel.toggleAddingSubtask,
                        accent: accent,
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}

/// Inline subtask add input that scrolls itself into view on mount.
class _SubtaskAddInput extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;
  final _key = GlobalKey();

  _SubtaskAddInput({required this.viewModel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    // Scroll into view after the frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });

    return Padding(
      key: _key,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: TaskInputWidget(
        onSave:
            ({
              required name,
              required description,
              time,
              deadline,
              required isFavorite,
              List<String> tagIds = const [],
              String? workspaceId,
            }) {
              viewModel.addSubtask(
                name: name,
                description: description,
                time: time ?? '00:00',
                deadline: deadline,
                isFavorite: isFavorite,
              );
              onSave();
            },
        onCancel: viewModel.toggleAddingSubtask,
        hintText: 'Nom de la sous-tâche',
      ),
    );
  }
}
