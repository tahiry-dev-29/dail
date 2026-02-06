import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FolderTaskTile extends StatelessWidget {
  final TaskEntity task;

  const FolderTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected =
        sl<WorkspaceViewModel>().selectedItemId.watch(context) == task.id;

    return InkWell(
      onTap: () {
        sl<WorkspaceViewModel>().selectTask(task.id);
        sl<HomeViewModel>().switchTab(AppTabs.workspace.index);
        if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: task.isDone,
                onChanged: (_) => sl<TaskListViewModel>().toggleTask(task.id),
                shape: const CircleBorder(),
                activeColor: colors.accent,
                side: BorderSide(
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(task.iconEmoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                task.name,
                style: context.bodyMedium.copyWith(
                  color: task.isDone
                      ? colors.textSecondary.withValues(alpha: 0.5)
                      : (isSelected ? colors.accent : colors.textPrimary),
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
