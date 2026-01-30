import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.isSubtasksExpanded.value = !isExpanded,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SOUS-TÂCHES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (!isAdding)
                IconButton(
                  onPressed: controller.toggleAddingSubtask,
                  icon: Icon(Icons.add, size: 20, color: accent),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const SizedBox(width: 12),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.white30,
              ),
            ],
          ),
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
                        children: subtasks.map((st) {
                          final isEditing = editingId == st.id;

                          if (isEditing) {
                            return Padding(
                              key: ValueKey('edit_${st.id}'),
                              padding: const EdgeInsets.only(bottom: 12),
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
                                      time,
                                      deadline,
                                      required isFavorite,
                                    }) {
                                      controller.updateSubtask(
                                        st.id,
                                        name: name,
                                        description: description,
                                        time: time ?? '00:00',
                                        deadline: deadline,
                                        isFavorite: isFavorite,
                                      );
                                      onSave();
                                    },
                                onCancel: () =>
                                    controller.setEditingSubtask(null),
                                hintText: 'Modifier la sous-tâche',
                              ),
                            );
                          }

                          // Prepare texts
                          final hasTime =
                              st.time != '00:00' && st.time.isNotEmpty;
                          final hasDeadline = st.deadline != null;

                          return ReorderableDragStartListener(
                            key: ValueKey(st.id),
                            index: subtasks.indexOf(st),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: GlassCard(
                                  borderRadius: 16,
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.toggleSubtaskDone(st.id);
                                          onSave();
                                        },
                                        child: Icon(
                                          st.isDone
                                              ? FontAwesomeIcons
                                                    .solidCircleCheck
                                              : FontAwesomeIcons.circle,
                                          size: 18,
                                          color: st.isDone
                                              ? Colors.greenAccent
                                              : Colors.white30,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => controller
                                              .setEditingSubtask(st.id),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                st.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  decoration: st.isDone
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                ),
                                              ),
                                              if (hasTime || hasDeadline)
                                                Text(
                                                  '${hasTime ? st.time : ""}${(hasTime && hasDeadline) ? " • " : ""}${hasDeadline ? DateFormat("dd/MM").format(st.deadline!) : ""}',
                                                  style: const TextStyle(
                                                    color: Colors.white30,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (st.isFavorite)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: Icon(
                                            FontAwesomeIcons.solidHeart,
                                            size: 10,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      // Direct Action Icons
                                      _ActionIcon(
                                        icon:
                                            FontAwesomeIcons.arrowUpFromBracket,
                                        onTap: () {
                                          controller.promoteSubtask(st.id, ref);
                                          onSave();
                                        },
                                        color: Colors.blueAccent,
                                      ),
                                      _ActionIcon(
                                        icon: FontAwesomeIcons.eye,
                                        onTap: () =>
                                            controller.setEditingSubtask(st.id),
                                        color: Colors.white30,
                                      ),
                                      _ActionIcon(
                                        icon: FontAwesomeIcons.trash,
                                        onTap: () {
                                          controller.deleteSubtask(st.id);
                                          onSave();
                                        },
                                        color: Colors.redAccent.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                      TextButton.icon(
                        onPressed: controller.toggleAddingSubtask,
                        icon: Icon(Icons.add, size: 16, color: accent),
                        label: Text(
                          'Ajouter une sous-tâche',
                          style: TextStyle(color: accent, fontSize: 13),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
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

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }
}
