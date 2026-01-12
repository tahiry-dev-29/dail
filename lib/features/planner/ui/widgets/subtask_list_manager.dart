import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../providers/task_edit_controller.dart';
import 'task_input_widget.dart';
import '../../../../core/theme/adaptive_colors.dart';

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
    final isExpanded = controller.isSubtasksExpanded.watch(context);
    final isAdding = controller.isAddingSubtask.watch(context);
    final editingId = controller.editingSubtaskId.watch(context);

    final colors = context.colors;
    final textSecondary = colors.textSecondary;
    final textHint = colors.textSecondary.withValues(alpha: 0.5);
    final textMuted = colors.textSecondary.withValues(alpha: 0.7);
    final textNorm = colors.textPrimary;
    final accent = colors.accent;

    Widget buildOptionItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: InkWell(
          onTap: controller.toggleSubtasks,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Icon(
                  FontAwesomeIcons.codeBranch,
                  size: 18,
                  color: subtasks.isNotEmpty ? accent : textSecondary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Add subtasks',
                  style: TextStyle(
                    color: subtasks.isNotEmpty ? accent : textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                isExpanded
                    ? FontAwesomeIcons.chevronDown
                    : FontAwesomeIcons.chevronRight,
                size: 12,
                color: textHint,
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSubtaskItem(dynamic st, int index) {
      if (editingId == st.id) {
        return Padding(
          key: ValueKey(st.id), // Important for ReorderableListView
          padding: const EdgeInsets.only(left: 44, bottom: 12),
          child: TaskInputWidget(
            initialValues: {
              'name': st.name,
              'description': st.description,
              'time': st.time,
              'deadline': st.deadline,
              'isFavorite': st.isFavorite,
            },
            onSave:
                ({
                  required name,
                  required description,
                  required time,
                  deadline,
                  required isFavorite,
                }) {
                  controller.updateSubtask(
                    st.id,
                    name: name,
                    description: description,
                    time: time,
                    deadline: deadline,
                    isFavorite: isFavorite,
                  );
                  onSave();
                },
            onCancel: () => controller.setEditingSubtask(null),
            hintText: 'Modifier la sous-tâche',
          ),
        );
      }

      return ReorderableDragStartListener(
        key: ValueKey(st.id),
        index: index,
        child: Padding(
          padding: const EdgeInsets.only(left: 44, bottom: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.toggleSubtaskDone(st.id);
                  onSave();
                },
                child: Icon(
                  st.isDone
                      ? FontAwesomeIcons.solidCircleCheck
                      : FontAwesomeIcons.circle,
                  size: 16,
                  color: st.isDone ? accent : textHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.setEditingSubtask(st.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        st.name,
                        style: TextStyle(
                          color: st.isDone ? textMuted : textNorm,
                          decoration: st.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (st.time != '00:00' || st.deadline != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${st.time}${st.deadline != null ? " • ${DateFormat("dd/MM").format(st.deadline!)}" : ""}',
                            style: TextStyle(color: textMuted, fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (st.isFavorite)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    size: 10,
                    color: Colors.amber,
                  ),
                ),
              // Drag Handle (Optional, but ReorderableDragStartListener covers the whole item usually, or we wrap specific part)
              // Here we wrap the whole item. But we also have a popup menu.
              // ReorderableDragStartListener intercepts checks.
              // To avoid conflict with tap, we need to ensure long press triggers drag.
              // ReorderableListView default is long press.
              // Tap on row triggers edit.
              // Pop menu on right.
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 14, color: textMuted),
                padding: EdgeInsets.zero,
                offset: const Offset(0, 20),
                onSelected: (value) {
                  if (value == 'promote') {
                    controller.promoteSubtask(st.id, ref);
                    onSave();
                  } else if (value == 'delete') {
                    controller.deleteSubtask(st.id);
                    onSave();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'promote',
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.arrowUpRightFromSquare,
                          size: 12,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Convert to main task',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.trash,
                          size: 12,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildOptionItem(),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtasks.isNotEmpty)
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subtasks.length,
                        onReorder: controller.reorderSubtasks,
                        itemBuilder: (context, index) {
                          return buildSubtaskItem(subtasks[index], index);
                        },
                      ),

                    Padding(
                      padding: const EdgeInsets.only(left: 44, bottom: 24),
                      child: isAdding
                          ? TaskInputWidget(
                              onSave:
                                  ({
                                    required name,
                                    required description,
                                    required time,
                                    deadline,
                                    required isFavorite,
                                  }) {
                                    controller.addSubtask(
                                      name: name,
                                      description: description,
                                      time: time,
                                      deadline: deadline,
                                      isFavorite: isFavorite,
                                    );
                                    onSave();
                                  },
                              onCancel: controller.toggleAddingSubtask,
                              hintText: 'Nom de la sous-tâche',
                            )
                          : TextButton.icon(
                              onPressed: controller.toggleAddingSubtask,
                              icon: Icon(Icons.add, size: 16, color: accent),
                              label: Text(
                                'Ajouter une ligne',
                                style: TextStyle(color: accent, fontSize: 13),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
