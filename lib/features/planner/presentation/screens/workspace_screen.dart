import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/markdown_editor/markdown_note_editor.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/screens/dashboard_view.dart';
import 'package:daily_os/features/planner/presentation/screens/task_edit_page.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Main workspace content area. Routes between dashboard, note, task, search.
class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceVM = sl<WorkspaceViewModel>();
    final contentType = workspaceVM.selectedContentType.watch(context);
    final selectedItemId = workspaceVM.selectedItemId.watch(context);

    // Sync ActivePageViewModel reactively
    if (contentType == WorkspaceContentType.note && selectedItemId != null) {
      sl<ActivePageViewModel>().setActivePageId(selectedItemId);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildContent(context, contentType, selectedItemId),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WorkspaceContentType type,
    String? id,
  ) {
    return switch (type) {
      WorkspaceContentType.dashboard => const DashboardView(),
      WorkspaceContentType.note =>
        id != null
            ? _buildNoteView(context, id)
            : EmptyState(
                icon: Icons.description_outlined,
                title: 'Aucune note sélectionnée',
                subtitle:
                    'Choisissez une note dans la barre latérale pour commencer.',
              ),
      WorkspaceContentType.task =>
        id != null
            ? _buildTaskView(context, id)
            : EmptyState(
                icon: Icons.check_circle_outline_rounded,
                title: 'Aucune tâche sélectionnée',
                subtitle: 'Sélectionnez une tâche pour voir ses détails.',
              ),
      WorkspaceContentType.search => EmptyState(
        icon: Icons.search_rounded,
        title: 'Résultats de recherche',
        subtitle: 'La recherche sera bientôt disponible.',
      ),
    };
  }

  Widget _buildNoteView(BuildContext context, String pageId) {
    final activePageVM = sl<ActivePageViewModel>();
    final pageState = activePageVM.activePage.watch(context);

    return pageState.map(
      data: (page) => page != null
          ? MarkdownNoteEditor(page: page)
          : const Center(child: Text('Note not found')),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildTaskView(BuildContext context, String taskId) {
    final taskListVM = sl<TaskListViewModel>();
    final tasksState = taskListVM.tasks.watch(context);

    return tasksState.map(
      data: (tasks) {
        final task = tasks.firstWhere(
          (t) => t.id == taskId,
          orElse: () => TaskEntity(
            id: taskId,
            name: 'Loading...',
            time: '00:00',
            date: DateTime.now(),
          ),
        );
        if (task.name == 'Loading...') {
          return const Center(child: CircularProgressIndicator());
        }
        return TaskEditPage(
          task: task,
          onBack: () => sl<WorkspaceViewModel>().showDashboard(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
