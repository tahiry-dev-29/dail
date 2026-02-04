import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_check_circle.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_deadline_badge.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_subtask_indicator.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_time_badge.dart';
import 'package:daily_os/features/planner/presentation/screens/task_edit_page.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
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

                          // Workspace Indicator
                          if (task.workspaceId != null)
                            Watch((context) {
                              final wsState = sl<WorkspaceViewModel>()
                                  .workspaces
                                  .watch(context);
                              return wsState.maybeMap(
                                data: (workspaces) {
                                  final ws = workspaces.firstWhere(
                                    (w) => w.id == task.workspaceId,
                                    orElse: () => workspaces.first,
                                  );
                                  return Text(
                                    ws.iconEmoji,
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
                              );
                            }),

                          // Tag Dots
                          if (task.tagIds.isNotEmpty)
                            Watch((context) {
                              final tagState = sl<TagViewModel>().tags.watch(
                                context,
                              );
                              return tagState.maybeMap(
                                data: (tags) {
                                  final taskTags = tags
                                      .where((t) => task.tagIds.contains(t.id))
                                      .toList();
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: taskTags
                                        .map(
                                          (tag) => Container(
                                            margin: const EdgeInsets.only(
                                              right: 4,
                                            ),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                      tag.color.substring(1),
                                                      radix: 16,
                                                    ) +
                                                    0xFF000000,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
                              );
                            }),
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
                          ? AppIcons.favorite(context, true)
                          : AppIcons.favorite(context, false),
                      onTap: onFavorite ?? () {},
                      color: task.isFavorite
                          ? Colors.redAccent
                          : colors.textSecondary.withValues(alpha: 0.3),
                      size: 16,
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(height: 4),
                    ActionIcon(
                      icon: AppIcons.delete(context),
                      onTap: () {
                        onDelete();
                        ToastService.error(context, '🗑️ Supprimée');
                      },
                      color: colors.textSecondary.withValues(alpha: 0.2),
                      size: 14,
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
