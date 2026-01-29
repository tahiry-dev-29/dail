import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../task_edit_page.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../data/task_model.dart';
import '../../providers/task_provider.dart';
import '../../../../core/theme/adaptive_colors.dart';
import '../../../../shared/utils/toast_service.dart';
import '../../../../core/utils/app_icons.dart';

import 'task_list/action_icon.dart';
import 'task_list/check_circle.dart';
import 'task_list/deadline_badge.dart';
import 'task_list/subtask_indicator.dart';
import 'task_list/time_badge.dart';

class TaskListItem extends ConsumerWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textPrimary = colors.textPrimary;
    final mutedIcon = colors.textSecondary;
    final accent = colors.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Opacity(
        opacity: task.isDone || task.isIgnored ? 0.55 : 1.0,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
          ),
          child: GlassContainer(
            borderRadius: 18,
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Check Circle
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: CheckCircle(
                    isDone: task.isDone,
                    isIgnored: task.isIgnored,
                    accent: accent,
                    mutedIcon: mutedIcon,
                    onTap: () {
                      onToggle();
                      if (!task.isDone) {
                        ToastService.success(
                          context,
                          '✨ "${task.name}" terminée !',
                        );
                      } else {
                        ToastService.info(context, '"${task.name}" réactivée');
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Center: Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Name
                      Text(
                        task.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone || task.isIgnored
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: mutedIcon,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Bottom Row: Time + Indicators
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Time Badge
                          TimeBadge(
                            time: task.time,
                            isOverdue:
                                task.isOverdue &&
                                !task.isDone &&
                                !task.isIgnored,
                            accent: accent,
                          ),

                          // Deadline Badge
                          if (task.deadline != null)
                            DeadlineBadge(deadline: task.deadline!),

                          // Indicators
                          if (task.description.isNotEmpty)
                            Icon(
                              FontAwesomeIcons.alignLeft,
                              size: 10,
                              color: mutedIcon.withValues(alpha: 0.5),
                            ),
                          if (task.subtasks.isNotEmpty)
                            SubtaskIndicator(
                              done: task.subtasks.where((s) => s.isDone).length,
                              total: task.subtasks.length,
                              color: mutedIcon,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right: Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ActionIcon(
                      icon: AppIcons.favorite(
                        context,
                        task.id == task.id ? task.isFavorite : false,
                      ),
                      color: task.isFavorite
                          ? Colors.redAccent
                          : mutedIcon.withValues(alpha: 0.4),
                      onTap: () {
                        ref.read(taskProvider.notifier).toggleFavorite(task.id);
                        if (!task.isFavorite) {
                          ToastService.success(context, '❤️ Coup de cœur !');
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    ActionIcon(
                      icon: AppIcons.delete(context),
                      color: mutedIcon.withValues(alpha: 0.4),
                      onTap: () {
                        onDelete();
                        ToastService.error(context, '🗑️ Supprimée');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
