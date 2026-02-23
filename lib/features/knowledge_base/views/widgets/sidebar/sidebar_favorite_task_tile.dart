import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';

class SidebarFavoriteTaskTile extends StatelessWidget {
  final TaskEntity task;

  const SidebarFavoriteTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final taskListVM = sl<TaskListViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        onTap: () {
          taskListVM.selectFolder(task.folderId);
          sl<HomeViewModel>().switchTab(AppTabs.workspace.index);
          if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Text(task.iconEmoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 12, color: Colors.amber.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
