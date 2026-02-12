import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_check_circle.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_tile_actions.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_tile_content.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final bool isDragging;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onFavorite,
    this.onTap,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // We removed 'isOverdue' calculation here since it's now internal to TaskTileContent for display.

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Opacity(
        opacity: task.isDone ? 0.6 : 1.0,
        child: GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
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
                  Expanded(child: TaskTileContent(task: task)),
                  const SizedBox(width: 12),
                  if (isDragging)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        color: colors.textSecondary.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    )
                  else
                    TaskTileActions(
                      task: task,
                      onDelete: onDelete,
                      onFavorite: onFavorite,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
