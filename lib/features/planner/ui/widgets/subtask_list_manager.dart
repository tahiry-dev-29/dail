import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../providers/task_edit_controller.dart';
import 'task_input_widget.dart';

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
    // Signals
    final subtasks = controller.subtasks.watch(context);
    final isExpanded = controller.isSubtasksExpanded.watch(context);
    final isAdding = controller.isAddingSubtask.watch(context);
    final editingId = controller.editingSubtaskId.watch(context);

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
                  color: subtasks.isNotEmpty
                      ? Colors.blueAccent
                      : Colors.white60,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Add subtasks',
                  style: TextStyle(
                    color: subtasks.isNotEmpty
                        ? Colors.blueAccent
                        : Colors.white60,
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
                color: Colors.white24,
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSubtaskItem(dynamic st) {
      if (editingId == st.id) {
        return Padding(
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

      return Padding(
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
                color: st.isDone ? Colors.blueAccent : Colors.white24,
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
                        color: st.isDone ? Colors.white38 : Colors.white70,
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
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
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
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 14,
                color: Colors.white38,
              ),
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
                        color: Colors.white70,
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
                        style: TextStyle(fontSize: 13, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
                    ...subtasks.map((st) => buildSubtaskItem(st)),
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
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.blueAccent,
                              ),
                              label: const Text(
                                'Ajouter une ligne',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 13,
                                ),
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
