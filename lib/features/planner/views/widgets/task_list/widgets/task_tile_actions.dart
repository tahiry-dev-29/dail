import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class TaskTileActions extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onDelete;
  final VoidCallback? onFavorite;

  const TaskTileActions({
    super.key,
    required this.task,
    required this.onDelete,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
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
    );
  }
}
