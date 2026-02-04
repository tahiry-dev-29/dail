import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/command_bar/search_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/folder_tree_item.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/recent_pages_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/workspace_switcher_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/tags/tag_manager_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/trash/trash_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class KnowledgeBaseSidebar extends HookWidget {
  const KnowledgeBaseSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel dependencies
    final workspaceVM = sl<WorkspaceViewModel>();
    final activeWorkspace = workspaceVM.activeWorkspace.watch(context);
    final workspacesState = workspaceVM.workspaces.watch(context);
    final folderTreeVM = sl<FolderTreeViewModel>();

    // Load folders when workspace changes
    useEffect(() {
      if (activeWorkspace != null) {
        folderTreeVM.loadRootFolders(activeWorkspace.id);
      }
      return null;
    }, [activeWorkspace?.id]);

    final rootFoldersState = folderTreeVM.rootFolders.watch(context);

    return Container(
      color: context.colors.surface,
      child: Column(
        children: [
          _buildWorkspaceSelector(context),
          const Divider(height: 1),
          _buildQuickActions(context),
          const Divider(height: 1),
          Expanded(
            child: () {
              if (activeWorkspace == null) {
                return workspacesState.map(
                  data: (_) =>
                      const Center(child: Text('No workspace selected')),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              }

              return rootFoldersState.map(
                data: (folders) {
                  return CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          return FolderTreeItem(folder: folders[index]);
                        },
                      ),
                      const SliverToBoxAdapter(child: Divider()),
                      _buildTagsSection(context),
                    ],
                  );
                },
                error: (error, _) => Center(child: Text('Error: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            }(),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildWorkspaceSelector(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final activeWorkspace = workspaceVM.activeWorkspace.watch(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.work_outline, size: 20, color: colors.textPrimary),
          const SizedBox(width: 8),
          Text(
            activeWorkspace?.name ?? 'My Workspace',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          ActionIcon(
            icon: Icons.unfold_more,
            size: 20,
            color: colors.textSecondary,
            onTap: () {
              WorkspaceSwitcherModal.show(context);
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        ListTile(
          leading: Icon(
            AppIcons.search(context),
            size: 20,
            color: colors.textSecondary,
          ),
          title: Text(
            'Search',
            style: context.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          onTap: () {
            SearchModal.show(context);
          },
          dense: true,
        ),
        ListTile(
          leading: Icon(
            AppIcons.clock(context),
            size: 20,
            color: colors.textSecondary,
          ),
          title: Text(
            'Recent',
            style: context.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          onTap: () {
            RecentPagesModal.show(context);
          },
          dense: true,
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    final colors = context.colors;
    final tagsState = sl<TagViewModel>().tags.watch(context);

    return tagsState.map(
      data: (tags) {
        if (tags.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TAGS',
                      style: context.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 14,
                        color: colors.textSecondary,
                      ),
                      onPressed: () => TagManagerModal.show(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Manage Tags',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((tag) => _buildTagChip(context, tag))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        );
      },
      error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Widget _buildTagChip(BuildContext context, TagEntity tag) {
    final colors = context.colors;

    // Parse hex color
    Color tagColor = colors.accent;
    try {
      if (tag.color.startsWith('#')) {
        tagColor = Color(
          int.parse(tag.color.substring(1), radix: 16) + 0xFF000000,
        );
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: tagColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tag, size: 12, color: tagColor),
          const SizedBox(width: 4),
          Text(
            tag.name,
            style: context.bodySmall.copyWith(
              color: colors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colors = context.colors;
    final folderTreeVM = sl<FolderTreeViewModel>();

    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: Icon(
            AppIcons.delete(context),
            size: 20,
            color: colors.textSecondary,
          ),
          title: Text(
            'Trash',
            style: context.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrashScreen()),
            );
          },
          dense: true,
        ),
        ListTile(
          leading: Icon(AppIcons.add(context), size: 20, color: colors.accent),
          title: Text(
            'New Page',
            style: context.bodyMedium.copyWith(color: colors.accent),
          ),
          onTap: () async {
            // Create in the first root folder found
            final rootFolders = folderTreeVM.rootFolders.value.value;
            if (rootFolders?.isNotEmpty == true) {
              await sl<ActivePageViewModel>().createNewPage(
                rootFolders!.first.id,
              );
            }
          },
          dense: true,
        ),
      ],
    );
  }
}
