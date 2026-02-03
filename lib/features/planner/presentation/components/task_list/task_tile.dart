import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_check_circle.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_deadline_badge.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_subtask_indicator.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_time_badge.dart';
import 'package:daily_os/features/planner/presentation/screens/task_edit_page.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onFavorite;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.accent;
    final mutedIcon = colors.textSecondary;

    final now = DateTime.now();
    final isOverdue = _checkOverdue(now);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: task.isDone ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
          ),
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: TaskCheckCircle(
                    isDone: task.isDone,
                    onToggle: () {
                      onToggle();
                      if (!task.isDone) {
                        ToastService.success(
                          context,
                          '✨ "${task.name}" terminée !',
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        task.name,
                        style: context.bodyLarge.copyWith(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isDone
                              ? colors.textSecondary.withValues(alpha: 0.5)
                              : colors.textPrimary,
                          fontWeight: .w600,
                        ),
                      ),
                      if (task.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.description,
                            style: context.bodySmall.copyWith(
                              color: colors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            maxLines: 2,
                            overflow: .ellipsis,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: .center,
                        children: [
                          if (task.time.isNotEmpty && task.time != '00:00')
                            TaskTimeBadge(
                              time: task.time,
                              isOverdue: isOverdue && !task.isDone,
                              accent: accent,
                            ),
                          if (task.deadline != null)
                            TaskDeadlineBadge(deadline: task.deadline!),
                          if (task.subtasks.isNotEmpty)
                            TaskSubtaskIndicator(
                              done: task.subtasks.where((s) => s.isDone).length,
                              total: task.subtasks.length,
                              color: mutedIcon.withValues(alpha: 0.6),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    ActionIcon(
                      icon: task.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      onTap: onFavorite ?? () {},
                      color: task.isFavorite
                          ? Colors.orangeAccent
                          : colors.textSecondary.withValues(alpha: 0.3),
                      size: 18,
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(height: 4),
                    ActionIcon(
                      icon: Icons.delete_outline_rounded,
                      onTap: () {
                        onDelete();
                        ToastService.error(context, '🗑️ Supprimée');
                      },
                      color: colors.textSecondary.withValues(alpha: 0.2),
                      size: 16,
                      padding: const EdgeInsets.all(8),
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

  bool _checkOverdue(DateTime now) {
    if (task.deadline != null && task.deadline!.isBefore(now)) return true;
    return false;
  }
}
