import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:daily_os/features/planner/views/widgets/active_tasks_section.dart';
import 'package:daily_os/features/planner/views/widgets/completed_tasks_section.dart';
import 'package:daily_os/features/planner/views/widgets/dashboard_header.dart';
import 'package:daily_os/features/planner/views/widgets/expired_tasks_section.dart';
import 'package:daily_os/features/planner/views/widgets/notes_section.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Dashboard view: scrollable sliver layout with tasks and notes sections.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskListVM = sl<TaskListViewModel>();
    final folderTreeVM = sl<FolderTreeViewModel>();
    final workspaceVM = sl<WorkspaceViewModel>();

    final selectedFolderId = taskListVM.selectedFolderId.watch(context);

    final title = _resolveTitle(selectedFolderId);

    return CustomScrollView(
      key: const ValueKey('dashboard'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: DashboardHeader(
            title: title,
            isFolder: selectedFolderId != null,
          ),
        ),

        // 1. Active Tasks
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: ActiveTasksSection(
            onToggle: (id) => sl<TaskListViewModel>().toggleTask(id),
            onDelete: (id) => sl<TaskListViewModel>().deleteTask(id),
            onFavorite: (id) => sl<TaskListViewModel>().toggleFavorite(id),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // 2. Notes
        Watch((context) {
          final notesState = selectedFolderId != null
              ? folderTreeVM.getPagesSignal(selectedFolderId).watch(context)
              : const AsyncData<List<PageEntity>>([]);

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: NotesSection(
              notesState: notesState,
              onNoteTap: (id) => workspaceVM.selectNote(id),
            ),
          );
        }),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // 3. Expired
        ExpiredTasksSection(
          onToggle: (id) => taskListVM.toggleTask(id),
          onDelete: (id) => taskListVM.deleteTask(id),
          onFavorite: (id) => taskListVM.toggleFavorite(id),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // 4. Completed
        CompletedTasksSection(
          onToggle: (id) => taskListVM.toggleTask(id),
          onDelete: (id) => taskListVM.deleteTask(id),
          onFavorite: (id) => taskListVM.toggleFavorite(id),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }

  String _resolveTitle(String? folderId) {
    if (folderId != null) {
      final folder = sl<FolderTreeViewModel>().getFolderSync(folderId);
      return folder?.name ?? 'Folder';
    }
    return 'Workspace';
  }
}
