import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/sidebar_signals.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_favorite_page_tile.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_favorite_task_tile.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_section_label.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SidebarFavoritesSection extends StatelessWidget {
  final WorkspaceEntity? activeWorkspace;

  const SidebarFavoritesSection({super.key, required this.activeWorkspace});

  @override
  Widget build(BuildContext context) {
    if (activeWorkspace == null) return const SliverToBoxAdapter();

    final taskListVM = sl<TaskListViewModel>();
    final folderTreeVM = sl<FolderTreeViewModel>();

    final tasksState = taskListVM.tasks.watch(context);
    final pagesState = folderTreeVM
        .getWorkspacePagesSignal(activeWorkspace!.id)
        .watch(context);

    final List<TaskEntity> favoriteTasks = _extractFavoriteTasks(
      tasksState,
      activeWorkspace!.id,
    );
    final List<PageEntity> favoritePages = _extractFavoritePages(pagesState);

    if (favoriteTasks.isEmpty && favoritePages.isEmpty) {
      return const SliverToBoxAdapter();
    }

    final isFavoritesExpanded = isFavoritesExpandedSignal.watch(context);
    final groupedItems = _groupFavoritesByFolder(favoriteTasks, favoritePages);

    return SliverMainAxisGroup(
      slivers: [
        SidebarSectionLabel(
          label: 'FAVORITES',
          isExpanded: isFavoritesExpanded,
          onToggle: () => isFavoritesExpandedSignal.value =
              !isFavoritesExpandedSignal.value,
        ),
        if (isFavoritesExpanded)
          SliverList.builder(
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final folderId = groupedItems.keys.elementAt(index);
              final items = groupedItems[folderId]!;
              return _FolderGroupItem(
                folderId: folderId,
                items: items,
                folderTreeVM: folderTreeVM,
              );
            },
          ),
      ],
    );
  }

  List<TaskEntity> _extractFavoriteTasks(dynamic state, String workspaceId) {
    if (state is AsyncData<List<TaskEntity>>) {
      return state.value
          .where((t) => t.isFavorite && t.workspaceId == workspaceId)
          .toList();
    }
    return [];
  }

  List<PageEntity> _extractFavoritePages(dynamic state) {
    if (state is AsyncData<List<PageEntity>>) {
      return state.value.where((p) => p.isFavorite).toList();
    }
    return [];
  }

  Map<String, List<dynamic>> _groupFavoritesByFolder(
    List<TaskEntity> tasks,
    List<PageEntity> pages,
  ) {
    final Map<String, List<dynamic>> grouped = {};
    for (final task in tasks) {
      grouped.putIfAbsent(task.folderId ?? 'root', () => []).add(task);
    }
    for (final page in pages) {
      grouped.putIfAbsent(page.folderId, () => []).add(page);
    }
    return grouped;
  }
}

class _FolderGroupItem extends StatelessWidget {
  final String folderId;
  final List<dynamic> items;
  final FolderTreeViewModel folderTreeVM;

  const _FolderGroupItem({
    required this.folderId,
    required this.items,
    required this.folderTreeVM,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFolderExpanded = getFavFolderExpandedSignal(
      folderId,
    ).watch(context);

    String folderName = 'No Folder';
    if (folderId != 'root') {
      folderName =
          folderTreeVM.getFolderSync(folderId)?.name ?? 'Unknown Folder';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (folderId != 'root')
          _buildFolderHeader(folderId, folderName, isFolderExpanded, colors),
        const SizedBox(height: 8),
        if (isFolderExpanded || folderId == 'root')
          ...items.map((item) {
            if (item is TaskEntity) return SidebarFavoriteTaskTile(task: item);
            if (item is PageEntity) return SidebarFavoritePageTile(page: item);
            return const SizedBox();
          }),
        if (isFolderExpanded || folderId == 'root') const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFolderHeader(
    String folderId,
    String folderName,
    bool isExpanded,
    AdaptiveColors colors,
  ) {
    return InkWell(
      onTap: () => getFavFolderExpandedSignal(folderId).value = !isExpanded,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 16, 4),
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.folder_open_rounded : Icons.folder_outlined,
              size: 14,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              folderName,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_right_rounded,
              size: 14,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
