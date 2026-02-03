import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_controller.dart';
import 'package:flutter/material.dart';

class FolderTile extends StatelessWidget {
  final FolderEntity folder;
  final bool isExpanded;
  final VoidCallback onTap;

  const FolderTile({
    super.key,
    required this.folder,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () {
        FolderTreeController.toggleFolder(folder.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          children: [
            // Icon changes based on expansion
            Icon(
              isExpanded
                  ? AppIcons.chevronDown(context)
                  : AppIcons.chevronRight(context),
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            // Custom Folder Icon if valid, else default
            Text(folder.iconEmoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                folder.name,
                style: TextStyle(color: colors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Hover actions (add page/folder) could go here
          ],
        ),
      ),
    );
  }
}
