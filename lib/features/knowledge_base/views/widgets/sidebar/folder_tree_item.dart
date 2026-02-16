import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/folder_task_tile.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/folder_tile.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/page_tile.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FolderTreeItem extends StatelessWidget {
  final FolderEntity folder;
  final int level;

  const FolderTreeItem({super.key, required this.folder, this.level = 0});

  @override
  Widget build(BuildContext context) {
    final folderTreeVM = sl<FolderTreeViewModel>();

    // Watch expanded state
    final expandedFolders = folderTreeVM.expandedFolders.watch(context);
    final isExpanded = expandedFolders.contains(folder.id);

    // ONLY WATCH if expanded
    final childrenState = isExpanded
        ? folderTreeVM.getChildrenSignal(folder.id).watch(context)
        : const AsyncLoading<List<FolderEntity>>();

    final pagesState = isExpanded
        ? folderTreeVM.getPagesSignal(folder.id).watch(context)
        : const AsyncLoading<List<PageEntity>>();

    // Watch tasks from the global TaskListViewModel to stay in sync
    final taskListVM = sl<TaskListViewModel>();
    final allTasksState = isExpanded
        ? taskListVM.tasks.watch(context)
        : const AsyncLoading<List<TaskEntity>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FolderTile(
          folder: folder,
          isExpanded: isExpanded,
          onExpand: () => folderTreeVM.toggleFolder(folder.id), // Chevron only
          onTap: () {
            // 1. Select folder in TaskListViewModel
            final taskListVM = sl<TaskListViewModel>();
            taskListVM.selectFolder(folder.id);

            // 2. Update WorkspaceViewModel state
            final workspaceVM = sl<WorkspaceViewModel>();
            workspaceVM.showDashboard();

            // Set active workspace to folder's workspace
            final workspaces = workspaceVM.workspaces.value.value ?? [];
            final folderWorkspace = workspaces
                .where((w) => w.id == folder.workspaceId)
                .firstOrNull;

            if (folderWorkspace != null) {
              workspaceVM.setActiveWorkspace(folderWorkspace);
            }

            // 3. Navigate to Workspace Tab
            sl<HomeViewModel>().switchTab(AppTabs.workspace.index);

            // 4. Close drawer if open
            if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
          },
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: [
                // Subfolders
                childrenState.map(
                  data: (children) => Column(
                    children: children
                        .map((c) => FolderTreeItem(folder: c, level: level + 1))
                        .toList(),
                  ),
                  error: (e, s) => const SizedBox.shrink(),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                // Pages
                pagesState.map(
                  data: (pages) => Column(
                    children: pages.map((p) => PageTile(page: p)).toList(),
                  ),
                  error: (e, s) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                // Tasks
                allTasksState.maybeMap(
                  data: (tasks) {
                    final folderTasks = tasks
                        .where((t) => t.folderId == folder.id)
                        .toList();
                    if (folderTasks.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: folderTasks
                          .map((t) => FolderTaskTile(task: t))
                          .toList(),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
