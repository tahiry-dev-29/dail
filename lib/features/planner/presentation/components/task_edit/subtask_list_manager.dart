import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_empty_state.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_header.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_item_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
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
                    if (subtasks.isNotEmpty)
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: false,
                        onReorder: (oldIndex, newIndex) {
                          viewModel.reorderSubtasks(oldIndex, newIndex);
                          onSave();
                        },
                        proxyDecorator: (child, index, animation) {
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (BuildContext context, Widget? child) {
                              return Material(
                                color: Colors.transparent,
                                child: GlassCard(
                                  borderRadius: 16,
                                  padding: EdgeInsets.zero,
                                  child: child ?? const SizedBox(),
                                ),
                              );
                            },
                            child: child,
                          );
                        },
                        children: subtasks.asMap().entries.map((entry) {
                          return SubtaskItemTile(
                            key: ValueKey(entry.value.id),
                            st: entry.value,
                            index: entry.key,
                            isEditing: editingId == entry.value.id,
                            viewModel: viewModel,
                            onSave: onSave,
                          );
                        }).toList(),
                      ),

                    // Add Input
                    if (isAdding)
                      Padding(
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
                      )
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
