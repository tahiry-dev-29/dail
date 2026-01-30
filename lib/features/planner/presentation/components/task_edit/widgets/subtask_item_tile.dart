import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SubtaskItemTile extends ConsumerWidget {
  final SubTaskEntity st;
  final bool isEditing;
  final TaskEditController controller;
  final VoidCallback onSave;
  final int index;

  const SubtaskItemTile({
    super.key,
    required this.st,
    required this.isEditing,
    required this.controller,
    required this.onSave,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onCancel: () => controller.setEditingSubtask(null),
          hintText: 'Modifier la sous-tâche',
        ),
      );
    }

    final hasTime = st.time != '00:00' && st.time.isNotEmpty;
    final hasDeadline = st.deadline != null;

    return ReorderableDragStartListener(
      key: ValueKey(st.id),
      index: index,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ActionIcon(
                  icon: st.isDone
                      ? AppIcons.circleCheck(context)
                      : AppIcons.solidCircle(context),
                  onTap: () {
                    controller.toggleSubtaskDone(st.id);
                    onSave();
                  },
                  color: st.isDone
                      ? Colors.greenAccent
                      : context.colors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.setEditingSubtask(st.id),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          st.name,
                          style: context.bodyMedium.copyWith(
                            decoration: st.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (hasTime || hasDeadline)
                          Text(
                            '${hasTime ? st.time : ""}${(hasTime && hasDeadline) ? " • " : ""}${hasDeadline ? DateFormat("dd/MM").format(st.deadline!) : ""}',
                            style: context.bodySmall.copyWith(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                ),
                if (st.isFavorite)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      AppIcons.favorite(context, true),
                      size: 10,
                      color: Colors.redAccent,
                    ),
                  ),
                ActionIcon(
                  icon: AppIcons.promote(context),
                  onTap: () {
                    controller.promoteSubtask(st.id, ref);
                    onSave();
                  },
                  color: Colors.blueAccent,
                ),
                ActionIcon(
                  icon: AppIcons.view(context),
                  onTap: () => controller.setEditingSubtask(st.id),
                  color: context.colors.textMuted,
                ),
                ActionIcon(
                  icon: AppIcons.delete(context),
                  onTap: () {
                    controller.deleteSubtask(st.id);
                    onSave();
                  },
                  color: Colors.redAccent.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
