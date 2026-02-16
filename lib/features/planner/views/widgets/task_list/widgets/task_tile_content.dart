import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/widgets/task_list/widgets/task_deadline_badge.dart';
import 'package:daily_os/features/planner/views/widgets/task_list/widgets/task_subtask_indicator.dart';
import 'package:daily_os/features/planner/views/widgets/task_list/widgets/task_time_badge.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskTileContent extends StatelessWidget {
  final TaskEntity task;

  const TaskTileContent({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.accent;
    final mutedIcon = colors.textSecondary;
    final now = DateTime.now();
    final isOverdue =
        task.deadline != null && task.deadline!.isBefore(now) && !task.isDone;

    // Watch signals once at the top to avoid nested Watch flickers
    final wsState = sl<WorkspaceViewModel>().workspaces.watch(context);
    final tagState = sl<TagViewModel>().tags.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (task.iconEmoji.isNotEmpty) ...[
              Text(task.iconEmoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                task.name,
                style: context.bodyLarge.copyWith(
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone
                      ? colors.textSecondary.withValues(alpha: 0.5)
                      : colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        if (task.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              task.description,
              style: context.bodySmall.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.7),
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
                isOverdue: isOverdue,
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
              wsState.maybeMap(
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
              ),

            // Tag Dots
            if (task.tagIds.isNotEmpty)
              tagState.maybeMap(
                data: (tags) {
                  final taskTags = tags
                      .where((t) => task.tagIds.contains(t.id))
                      .toList();
                  if (taskTags.isEmpty) return const SizedBox.shrink();

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: taskTags
                        .map(
                          (tag) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(tag.color.substring(1), radix: 16) +
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
              ),
          ],
        ),
      ],
    );
  }
}
