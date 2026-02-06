import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/markdown_editor/markdown_note_editor.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/screens/task_edit_page.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/widgets/empty_state.dart';
import 'package:daily_os/shared/widgets/expandable_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class WorkspaceScreen extends HookWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceVM = sl<WorkspaceViewModel>();
    final contentType = workspaceVM.selectedContentType.watch(context);
    final selectedItemId = workspaceVM.selectedItemId.watch(context);

    // Sync ActivePageViewModel when selectedItemId changes (for Notes)
    useEffect(() {
      if (contentType == WorkspaceContentType.note && selectedItemId != null) {
        sl<ActivePageViewModel>().setActivePageId(selectedItemId);
      }
      return null;
    }, [selectedItemId, contentType]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildContent(context, contentType, selectedItemId),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WorkspaceContentType type,
    String? id,
  ) {
    switch (type) {
      case WorkspaceContentType.dashboard:
        return _buildDashboard(context);
      case WorkspaceContentType.note:
        return id != null
            ? _buildNoteView(context, id)
            : EmptyState(
                icon: Icons.description_outlined,
                title: 'Aucune note sélectionnée',
                subtitle:
                    'Choisissez une note dans la barre latérale pour commencer.',
              );
      case WorkspaceContentType.task:
        return id != null
            ? _buildTaskView(context, id)
            : EmptyState(
                icon: Icons.check_circle_outline_rounded,
                title: 'Aucune tâche sélectionnée',
                subtitle: 'Sélectionnez une tâche pour voir ses détails.',
              );
      case WorkspaceContentType.search:
        return EmptyState(
          icon: Icons.search_rounded,
          title: 'Résultats de recherche',
          subtitle: 'La recherche sera bientôt disponible.',
        );
    }
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

  Widget _buildDashboard(BuildContext context) {
    final colors = context.colors;
    final taskListVM = sl<TaskListViewModel>();
    final folderTreeVM = sl<FolderTreeViewModel>();
    final workspaceVM = sl<WorkspaceViewModel>();

    final tasksState = taskListVM.filteredTasks.watch(context);
    final selectedFolderId = taskListVM.selectedFolderId.watch(context);

    // Get notes for the current folder if selected
    final notesState = selectedFolderId != null
        ? folderTreeVM.getPagesSignal(selectedFolderId).watch(context)
        : const AsyncData<List<PageEntity>>([]);

    return CustomScrollView(
      key: const ValueKey('dashboard'),
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      selectedFolderId != null
                          ? Icons.folder_open_rounded
                          : Icons.grid_view_rounded,
                      size: 28,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getContentTitle(
                        WorkspaceContentType.dashboard,
                        null,
                        selectedFolderId,
                      ),
                      style: AppTypography.h2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    _buildFilterButton(context),
                  ],
                ),
                if (selectedFolderId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Contenu du dossier',
                      style: context.bodySmall.copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Content Sections
        tasksState.map(
          data: (tasks) {
            final now = DateTime.now();

            final activeTasks = tasks
                .where(
                  (t) =>
                      !t.isDone &&
                      !t.isIgnored &&
                      (t.deadline == null || t.deadline!.isAfter(now)),
                )
                .toList();
            final completedTasks = tasks.where((t) => t.isDone).toList();
            final expiredTasks = tasks
                .where(
                  (t) =>
                      !t.isDone &&
                      t.deadline != null &&
                      t.deadline!.isBefore(now),
                )
                .toList();

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. ACTIVE TASKS
                  ExpandableSection(
                    title: 'TÂCHES ACTIVES',
                    icon: Icons.check_circle_outline_rounded,
                    trailing: _buildCountBadge(context, activeTasks.length),
                    child: activeTasks.isEmpty
                        ? _buildEmptySection(context, 'Aucune tâche active')
                        : Column(
                            children: activeTasks
                                .map(
                                  (task) => TaskTile(
                                    task: task,
                                    onToggle: () =>
                                        taskListVM.toggleTask(task.id),
                                    onDelete: () =>
                                        taskListVM.deleteTask(task.id),
                                  ),
                                )
                                .toList(),
                          ),
                  ),

                  // 2. NOTES (PAGES)
                  notesState.map(
                    data: (notes) => ExpandableSection(
                      title: 'NOTES',
                      icon: Icons.description_outlined,
                      trailing: _buildCountBadge(context, notes.length),
                      child: notes.isEmpty
                          ? _buildEmptySection(
                              context,
                              'Aucune note dans ce dossier',
                            )
                          : Column(
                              children: notes
                                  .map(
                                    (note) => _buildNoteTile(
                                      context,
                                      note,
                                      workspaceVM,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),

                  // 3. EXPIRED
                  if (expiredTasks.isNotEmpty)
                    ExpandableSection(
                      title: 'EXPIRÉ',
                      icon: Icons.history_rounded,
                      isInitialExpanded: false,
                      trailing: _buildCountBadge(
                        context,
                        expiredTasks.length,
                        isError: true,
                      ),
                      child: Column(
                        children: expiredTasks
                            .map(
                              (task) => TaskTile(
                                task: task,
                                onToggle: () => taskListVM.toggleTask(task.id),
                                onDelete: () => taskListVM.deleteTask(task.id),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  // 4. COMPLETED
                  if (completedTasks.isNotEmpty)
                    ExpandableSection(
                      title: 'TERMINÉ',
                      icon: Icons.task_alt_rounded,
                      isInitialExpanded: false,
                      trailing: _buildCountBadge(
                        context,
                        completedTasks.length,
                        isAccent: false,
                      ),
                      child: Column(
                        children: completedTasks
                            .map(
                              (task) => TaskTile(
                                task: task,
                                onToggle: () => taskListVM.toggleTask(task.id),
                                onDelete: () => taskListVM.deleteTask(task.id),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ]),
              ),
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) =>
              SliverFillRemaining(child: Center(child: Text('Error: $e'))),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCountBadge(
    BuildContext context,
    int count, {
    bool isError = false,
    bool isAccent = true,
  }) {
    final colors = context.colors;
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isError
            ? colors.error.withValues(alpha: 0.1)
            : (isAccent
                  ? colors.accent.withValues(alpha: 0.1)
                  : colors.textSecondary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: context.caption.copyWith(
          color: isError
              ? colors.error
              : (isAccent ? colors.accent : colors.textSecondary),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Text(
        message,
        style: context.bodySmall.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildNoteTile(
    BuildContext context,
    PageEntity note,
    WorkspaceViewModel workspaceVM,
  ) {
    final colors = context.colors;
    return InkWell(
      onTap: () => workspaceVM.selectNote(note.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Text(note.iconEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                note.title,
                style: context.bodyMedium.copyWith(color: colors.textPrimary),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.tune_rounded, color: context.colors.textSecondary),
      onPressed: () {
        // TODO: Show Filter Bottom Sheet
      },
    );
  }

  String _getContentTitle(
    WorkspaceContentType type,
    String? id,
    String? folderId,
  ) {
    if (type == WorkspaceContentType.dashboard && folderId != null) {
      final folder = sl<FolderTreeViewModel>().getFolderSync(folderId);
      return folder?.name ?? 'Folder';
    }
    switch (type) {
      case WorkspaceContentType.dashboard:
        return 'Workspace';
      case WorkspaceContentType.note:
        return 'Note';
      case WorkspaceContentType.task:
        return 'Task';
      case WorkspaceContentType.search:
        return 'Search';
    }
  }
}
