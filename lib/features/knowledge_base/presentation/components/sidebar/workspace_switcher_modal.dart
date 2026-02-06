import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class WorkspaceSwitcherModal extends StatelessWidget {
  const WorkspaceSwitcherModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const WorkspaceSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();

    final workspacesAsync = workspaceVM.workspaces.watch(context);
    final activeWorkspace = workspaceVM.activeWorkspace.watch(context);

    // Bottom sheet style
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Switch Workspace',
                  style: context.h2.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCreateWorkspaceDialog(context, workspaceVM);
                  },
                  icon: Icon(Icons.add, size: 16, color: colors.accent),
                  label: Text(
                    'New',
                    style: context.bodyMedium.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: workspacesAsync.map(
              data: (workspaces) {
                if (workspaces.isEmpty) {
                  return const Center(child: Text("No workspaces found."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: workspaces.length,
                  itemBuilder: (context, index) {
                    final ws = workspaces[index];
                    final isSelected = ws.id == activeWorkspace?.id;

                    return _WorkspaceListTile(
                      workspace: ws,
                      isSelected: isSelected,
                      onTap: () {
                        workspaceVM.setActiveWorkspace(ws);
                        workspaceVM.showDashboard();
                        sl<HomeViewModel>().switchTab(AppTabs.workspace.index);
                        Navigator.pop(context);
                      },
                      onDelete: () {
                        _showDeleteConfirmDialog(context, workspaceVM, ws);
                      },
                    );
                  },
                );
              },
              error: (err, _) => Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WorkspaceViewModel workspaceVM,
    WorkspaceEntity workspace,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace?'),
        content: Text('Are you sure you want to delete "${workspace.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              workspaceVM.deleteWorkspace(workspace.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateWorkspaceDialog(
    BuildContext context,
    WorkspaceViewModel workspaceVM,
  ) {
    final nameController = TextEditingController();
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'New Workspace',
          style: context.h2.copyWith(color: colors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: context.bodyMedium.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Workspace Name',
                labelStyle: context.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.accent),
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: context.bodyMedium.copyWith(color: colors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final workspace = WorkspaceEntity(
                  id: Uuid().v4(),
                  name: name,
                  iconEmoji: '🚀',
                  createdAt: DateTime.now(),
                );
                workspaceVM.createWorkspace(workspace);
                Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: colors.textOnAccent,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceListTile extends StatelessWidget {
  final WorkspaceEntity workspace;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WorkspaceListTile({
    required this.workspace,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? colors.accent
                : colors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Text(workspace.iconEmoji, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(
        workspace.name,
        style: context.bodyMedium.copyWith(
          color: isSelected ? colors.accent : colors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) Icon(Icons.check, color: colors.accent),
          if (!isSelected)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
              onPressed: onDelete,
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
