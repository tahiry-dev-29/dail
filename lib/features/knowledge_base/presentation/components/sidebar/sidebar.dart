import 'dart:ui' as ui;

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/folder_tree_item.dart'; // Added import
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/workspace_switcher_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/search_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/tag_customization_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/trash/trash_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart'; // TagVM import
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class KnowledgeBaseSidebar extends HookWidget {
  const KnowledgeBaseSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final activeWorkspace = workspaceVM.activeWorkspace.watch(context);

    // RESTORED: FolderTreeVM for Tree structure
    final folderTreeVM = sl<FolderTreeViewModel>();
    final rootFoldersState = folderTreeVM.rootFolders.watch(context);

    // RESTORED: TagVM for Tags
    final tagVM = sl<TagViewModel>();
    final tagState = tagVM.tags.watch(context);

    // Sidebar states
    final isTagsExpanded = useState(true);
    final isFoldersExpanded = useState(true);

    useEffect(() {
      // Trigger loadTags to verify seeding if empty
      tagVM.loadTags();
      return null;
    }, []);

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
                      _buildSectionLabel(
                        context,
                        'PRIVATE',
                        isExpanded: isFoldersExpanded.value,
                        onToggle: () =>
                            isFoldersExpanded.value = !isFoldersExpanded.value,
                      ),
                      if (isFoldersExpanded.value)
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
                        isExpanded: isTagsExpanded.value,
                        onToggle: () =>
                            isTagsExpanded.value = !isTagsExpanded.value,
                      ),
                      if (isTagsExpanded.value)
                        tagState.map(
                          data: (tags) {
                            // Sort by priority
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
                  fontWeight: FontWeight.bold,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        active?.name ?? 'Personal Workspace',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
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
          // Home removed as requested
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.textSecondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrashScreen()),
            ),
            tooltip: 'Trash',
          ),
          // REQUESTED: Add Menu
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
          mainAxisSize: MainAxisSize.min,
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
                  folderTreeVM.createFolder(
                    name: 'New Folder',
                    workspaceId: activeId,
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
            // Placeholder for Task and Note (Features not fully linked here yet)
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
          mainAxisSize: MainAxisSize.min,
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
            fontWeight: FontWeight.normal,
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
                    fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.bold,
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
