import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_empty_state.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_header.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/subtask_item_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Orchestrateur pour la gestion des sous-tâches.
/// Segmenté en micro-composants pour respecter la règle des 120 lignes (Standards 2026).
class SubtaskListManager extends ConsumerWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const SubtaskListManager({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtasks = controller.subtasks.watch(context);
    final isAdding = controller.isAddingSubtask.watch(context);
    final isExpanded = controller.isSubtasksExpanded.watch(context);
    final editingId = controller.editingSubtaskId.watch(context);
    final colors = context.colors;
    final accent = colors.accent;

    return Column(
      crossAxisAlignment: .start,
      children: [
        SubtaskHeader(
          controller: controller,
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
                          controller.reorderSubtasks(oldIndex, newIndex);
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
                            controller: controller,
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
                              }) {
                                controller.addSubtask(
                                  name: name,
                                  description: description,
                                  time: time ?? '00:00',
                                  deadline: deadline,
                                  isFavorite: isFavorite,
                                );
                                onSave();
                              },
                          onCancel: controller.toggleAddingSubtask,
                          hintText: 'Nom de la sous-tâche',
                        ),
                      )
                    else if (subtasks.isEmpty)
                      SubtaskEmptyState(
                        onPressed: controller.toggleAddingSubtask,
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
