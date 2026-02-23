import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/screens/tag_customization_screen.dart';
import 'package:daily_os/features/knowledge_base/views/screens/trash/trash_screen.dart';
import 'package:flutter/material.dart';

class SidebarFooter extends StatelessWidget {
  final WorkspaceViewModel workspaceVM;
  final FolderTreeViewModel folderTreeVM;
  final TagViewModel tagVM;

  const SidebarFooter({
    super.key,
    required this.workspaceVM,
    required this.folderTreeVM,
    required this.tagVM,
  });

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(Icons.add, color: colors.accent),
            onPressed: () => _showAddMenu(context),
            tooltip: 'Add New',
            style: IconButton.styleFrom(
              backgroundColor: colors.accent.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TagCustomizationScreen(),
                  ),
                );
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
}
