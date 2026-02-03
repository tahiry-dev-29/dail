import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_state.dart';
import 'package:daily_os/features/knowledge_base/logic/workspace_controller.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/command_bar/search_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/folder_tree_item.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/trash/trash_screen.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class KnowledgeBaseSidebar extends StatefulWidget {
  const KnowledgeBaseSidebar({super.key});

  @override
  State<KnowledgeBaseSidebar> createState() => _KnowledgeBaseSidebarState();
}

class _KnowledgeBaseSidebarState extends State<KnowledgeBaseSidebar> {
  @override
  void initState() {
    super.initState();
    // Initialize signals if not already done
    FolderTreeController.init();
    WorkspaceController.loadWorkspaces();
  }

  @override
  Widget build(BuildContext context) {
    final rootFoldersState = rootFoldersSignal.watch(context);

    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          _buildWorkspaceSelector(context),
          const Divider(height: 1),
          _buildQuickActions(context),
          const Divider(height: 1),
          Expanded(
            child: rootFoldersState.map(
              data: (folders) {
                if (folders.isEmpty) {
                  return const Center(child: Text('No folders'));
                }
                return CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        return FolderTreeItem(folder: folders[index]);
                      },
                    ),
                  ],
                );
              },
              error: (error, _) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildWorkspaceSelector(BuildContext context) {
    final colors = context.colors;
    // Placeholder for workspace selector
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.work_outline, size: 20, color: colors.textPrimary),
          const SizedBox(width: 8),
          Text(
            'My Workspace',
            style: TextStyle(
              fontWeight: FontWeight
                  .bold, // Dot shorthand .bold in 3.6, keeping explicit for safety if sdk < 3.6 configured but aiming for it
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          // Use ActionIcon for interaction
          ActionIcon(
            icon: Icons.unfold_more,
            size: 20,
            color: colors.textSecondary,
            onTap: () {
              // TODO: Open workspace switcher
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
          title: Text('Search', style: TextStyle(color: colors.textPrimary)),
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
          title: Text('Recent', style: TextStyle(color: colors.textPrimary)),
          onTap: () {},
          dense: true,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: Icon(
            AppIcons.delete(context),
            size: 20,
            color: colors.textSecondary,
          ),
          title: Text('Trash', style: TextStyle(color: colors.textPrimary)),
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
          title: Text('New Page', style: TextStyle(color: colors.accent)),
          onTap: () {
            // Create in the first root folder found or default if no folders
            final rootFolders = rootFoldersSignal.value.value;
            final folderId = rootFolders?.isNotEmpty == true
                ? rootFolders!.first.id
                : 'default-root';
            ActivePageController.createPage(
              title: 'Untitled',
              folderId: folderId,
            );
          },
          dense: true,
        ),
      ],
    );
  }
}
