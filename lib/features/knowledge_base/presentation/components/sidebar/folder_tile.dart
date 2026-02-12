import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/dialogs/delete_confirmation_dialog.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor_modal.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/folder_tree_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final FolderEntity folder;
  final bool isExpanded;
  final VoidCallback onTap; // Navigation
  final VoidCallback? onExpand; // Expand/Collapse chevron

  const FolderTile({
    super.key,
    required this.folder,
    required this.isExpanded,
    required this.onTap,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          // Chevron: dedicated expand/collapse button
          GestureDetector(
            onTap: onExpand,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                isExpanded
                    ? AppIcons.chevronDown(context)
                    : AppIcons.chevronRight(context),
                size: 16,
                color: colors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),
          // Folder content: navigation on tap
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Text(folder.iconEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      folder.name,
                      style: context.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_horiz,
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            padding: EdgeInsets.zero,
            onSelected: (value) async {
              final folderTreeVM = sl<FolderTreeViewModel>();
              final activePageVM = sl<ActivePageViewModel>();

              switch (value) {
                case 'new_task':
                  // Link to global overlay
                  sl<TaskListViewModel>().selectFolder(folder.id);
                  sl<HomeViewModel>().isAddTaskVisible.value = true;

                  // Close drawer
                  if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  }
                  break;
                case 'new_note':
                  await activePageVM.createNewPage(folder.id);
                  if (context.mounted) {
                    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                      Navigator.of(context).pop();
                    }
                    ToastService.success(
                      context,
                      'New note created in "${folder.name}"',
                    );
                    PageEditorModal.show(context);
                  }
                  break;
                case 'rename':
                  showDialog(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController(
                        text: folder.name,
                      );
                      return AlertDialog(
                        title: const Text('Rename Folder'),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Folder Name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () async {
                              final newName = controller.text.trim();
                              if (newName.isNotEmpty) {
                                await folderTreeVM.updateFolder(
                                  folder.copyWith(name: newName),
                                  folder.workspaceId,
                                );
                              }
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text('Rename'),
                          ),
                        ],
                      );
                    },
                  );
                  break;
                case 'delete':
                  DeleteConfirmationDialog.show(
                    context,
                    title: 'Delete Folder',
                    message:
                        'Are you sure you want to delete "${folder.name}" and all its contents?',
                    onConfirm: () => folderTreeVM.deleteFolder(
                      folder.id,
                      folder.parentId,
                      folder.workspaceId,
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_task',
                child: Row(
                  children: [
                    Icon(Icons.add_task, size: 18),
                    SizedBox(width: 8),
                    Text('New Task'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'new_note',
                child: Row(
                  children: [
                    Icon(Icons.note_add_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('New Note'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Rename'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: colors.error),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: colors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
