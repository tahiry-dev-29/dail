import 'dart:ui' as ui;

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/folder_tree_item.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/workspace_switcher_modal.dart';
import 'package:daily_os/features/knowledge_base/views/screens/search_screen.dart';
import 'package:daily_os/features/knowledge_base/views/screens/tag_customization_screen.dart';
import 'package:daily_os/features/knowledge_base/views/screens/trash/trash_screen.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Sidebar signals for expand state — persisted across rebuilds.
final _isTagsExpanded = signal(false);
final _isFoldersExpanded = signal(true);

class KnowledgeBaseSidebar extends StatelessWidget {
  const KnowledgeBaseSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final activeWorkspace = workspaceVM.activeWorkspace.watch(context);

    final folderTreeVM = sl<FolderTreeViewModel>();
    final rootFoldersState = folderTreeVM.rootFolders.watch(context);

    final tagVM = sl<TagViewModel>();
    final tagState = tagVM.tags.watch(context);

    final taskListVM = sl<TaskListViewModel>();

    // Watch expand signals
    final isTagsExp = _isTagsExpanded.watch(context);
    final isFoldersExp = _isFoldersExpanded.watch(context);

    // Sidebar Width: 85% of screen width (Mobile optimized)
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.85;

    return SizedBox(
      width: sidebarWidth,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: colors.blur, sigmaY: colors.blur),
          child: Container(
            decoration: BoxDecoration(
              color: colors.isGlass
                  ? (colors.isDark
                        ? Colors.black.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.85))
                  : colors.customSurface,
              border: Border(
                right: BorderSide(color: colors.border, width: 0.5),
              ),
            ),
            child: Column(
              children: [
                _buildWorkspaceHeader(context, activeWorkspace),
                _buildPrimaryNav(context),
                const SizedBox(height: 24),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildFavoritesSection(
                        context,
                        taskListVM,
                        folderTreeVM,
                        activeWorkspace,
                      ),
                      _buildSectionLabel(
                        context,
                        'PRIVATE',
                        isExpanded: isFoldersExp,
                        onToggle: () => _isFoldersExpanded.value =
                            !_isFoldersExpanded.value,
                      ),
                      if (isFoldersExp)
                        rootFoldersState.map(
                          data: (folders) => SliverList.builder(
                            itemCount: folders.length,
                            itemBuilder: (context, index) {
                              return FolderTreeItem(folder: folders[index]);
                            },
                          ),
                          error: (e, _) => SliverToBoxAdapter(
                            child: Center(child: Text('Error: $e')),
                          ),
                          loading: () => const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      _buildSectionLabel(
                        context,
                        'TAGS',
                        isExpanded: isTagsExp,
                        onToggle: () =>
                            _isTagsExpanded.value = !_isTagsExpanded.value,
                      ),
                      if (isTagsExp)
                        tagState.map(
                          data: (tags) {
                            final sortedTags = tags.toList()
                              ..sort(
                                (a, b) => a.priority.compareTo(b.priority),
                              );

                            return SliverList.builder(
                              itemCount: sortedTags.length,
                              itemBuilder: (context, index) {
                                return TagItem(
                                  tag: sortedTags[index],
                                  onAction: () => _showTagActionModal(
                                    context,
                                    sortedTags[index],
                                    tagVM,
                                  ),
                                );
                              },
                            );
                          },
                          error: (e, _) => SliverToBoxAdapter(
                            child: Center(child: Text('Error: $e')),
                          ),
                          loading: () => const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _buildFooter(context, workspaceVM, folderTreeVM, tagVM),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(
    BuildContext context,
    TaskListViewModel taskListVM,
    FolderTreeViewModel folderTreeVM,
    WorkspaceEntity? activeWorkspace,
  ) {
    final tasksState = taskListVM.tasks.watch(context);
    final colors = context.colors;

    return tasksState.maybeMap(
      data: (tasks) {
        // 1. Filter by Favorites AND Active Workspace
        final favorites = tasks.where((t) {
          if (!t.isFavorite) return false;
          if (activeWorkspace != null) {
            if (t.workspaceId != activeWorkspace.id) return false;
          }
          return true;
        }).toList();

        if (favorites.isEmpty) return const SliverToBoxAdapter();

        // 2. Group by Folder
        final Map<String, List<TaskEntity>> groupedTasks = {};
        for (final task in favorites) {
          final folderId = task.folderId ?? 'root';
          if (!groupedTasks.containsKey(folderId)) {
            groupedTasks[folderId] = [];
          }
          groupedTasks[folderId]!.add(task);
        }

        return SliverMainAxisGroup(
          slivers: [
            _buildSectionLabel(context, 'FAVORITES'),
            SliverList.builder(
              itemCount: groupedTasks.length,
              itemBuilder: (context, index) {
                final folderId = groupedTasks.keys.elementAt(index);
                final folderTasks = groupedTasks[folderId]!;

                String folderName = 'No Folder';
                if (folderId != 'root') {
                  final folder = folderTreeVM.getFolderSync(folderId);
                  folderName = folder?.name ?? 'Unknown Folder';
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (folderId != 'root')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 16, 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 14,
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              folderName,
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                                fontWeight: .w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Tasks in this folder
                    ...folderTasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        child: InkWell(
                          onTap: () {
                            taskListVM.selectFolder(task.folderId);
                            sl<HomeViewModel>().switchTab(
                              AppTabs.workspace.index,
                            );
                            if (Scaffold.maybeOf(context)?.isDrawerOpen ??
                                false) {
                              Navigator.of(context).pop();
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colors.border.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  task.iconEmoji,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    task.name,
                                    style: context.bodyMedium.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: .w500,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 12,
                                  color: Colors.amber.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ],
        );
      },
      orElse: () => const SliverToBoxAdapter(),
    );
  }

  Widget _buildSectionLabel(
    BuildContext context,
    String label, {
    bool? isExpanded,
    VoidCallback? onToggle,
  }) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
          child: Row(
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                  fontWeight: .bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (onToggle != null && isExpanded != null) ...[
                const Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 16,
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspaceHeader(BuildContext context, WorkspaceEntity? active) {
    final colors = context.colors;
    return InkWell(
      onTap: () => WorkspaceSwitcherModal.show(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.surface,
              child: Icon(Icons.person, color: colors.textSecondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Text(
                        active?.name ?? 'Personal Workspace',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: .w600,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          _NavItem(
            icon: Icons.search,
            label: 'Search',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WorkspaceViewModel workspaceVM,
    FolderTreeViewModel folderTreeVM,
    TagViewModel tagVM,
  ) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.surface, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.textSecondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrashScreen()),
            ),
            tooltip: 'Trash',
          ),
          IconButton(
            icon: Icon(Icons.add, color: colors.accent),
            onPressed: () =>
                _showAddMenu(context, folderTreeVM, tagVM, workspaceVM),
            tooltip: 'Add New',
            style: IconButton.styleFrom(
              backgroundColor: colors.accent.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMenu(
    BuildContext context,
    FolderTreeViewModel folderTreeVM,
    TagViewModel tagVM,
    WorkspaceViewModel workspaceVM,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: .min,
          children: [
            ListTile(
              leading: Icon(
                Icons.create_new_folder_outlined,
                color: context.colors.iconPrimary,
              ),
              title: Text('New Folder', style: AppTypography.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                final activeId = workspaceVM.activeWorkspace.value?.id;
                if (activeId != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController(
                        text: 'New Folder',
                      );
                      return AlertDialog(
                        title: const Text('New Folder'),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              final name = controller.text.trim();
                              if (name.isNotEmpty) {
                                folderTreeVM.createFolder(
                                  name: name,
                                  workspaceId: activeId,
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.label_outline,
                color: context.colors.iconPrimary,
              ),
              title: Text('New Tag', style: AppTypography.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _showCreateTagDialog(context, tagVM);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: context.colors.iconPrimary,
              ),
              title: Text(
                'New Task (Coming Soon)',
                style: AppTypography.bodyMedium,
              ),
              enabled: false,
            ),
            ListTile(
              leading: Icon(
                Icons.note_alt_outlined,
                color: context.colors.iconPrimary,
              ),
              title: Text(
                'New Note (Coming Soon)',
                style: AppTypography.bodyMedium,
              ),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showTagActionModal(
    BuildContext context,
    TagEntity tag,
    TagViewModel tagVM,
  ) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        borderRadius: 24,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: .min,
          children: [
            ListTile(
              leading: Icon(AppIcons.settings(context)),
              title: const Text("Modifier le Tag"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagCustomizationScreen(tag: tag),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(AppIcons.delete(context), color: colors.error),
              title: Text("Supprimer", style: TextStyle(color: colors.error)),
              onTap: () {
                tagVM.deleteTag(tag.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTagDialog(BuildContext context, TagViewModel tagVM) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TagCustomizationScreen()),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: colors.textSecondary, size: 22),
        title: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary.withValues(alpha: 0.8),
            fontWeight: .normal,
          ),
        ),
        dense: true,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final TagEntity tag;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const TagItem({super.key, required this.tag, this.onTap, this.onAction});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagColor = Color(int.parse(tag.color.replaceFirst('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tagColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: tagColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tag.name,
                  style: context.bodyMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: .w500,
                  ),
                ),
              ),
              if (tag.priority > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "P${tag.priority}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: .bold,
                      color: colors.accent,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 18),
                onPressed: onAction,
                visualDensity: VisualDensity.compact,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
