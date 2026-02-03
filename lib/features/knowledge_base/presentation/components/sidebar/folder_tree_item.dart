import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_state.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/folder_tile.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/page_tile.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FolderTreeItem extends StatelessWidget {
  final FolderEntity folder;
  final int level;

  const FolderTreeItem({super.key, required this.folder, this.level = 0});

  @override
  Widget build(BuildContext context) {
    // Watch expanded state
    final expandedFolders = expandedFoldersSignal.watch(context);
    final isExpanded = expandedFolders.contains(folder.id);

    // Watch children state for this folder
    final childrenState = FolderTreeController.getChildrenSignal(
      folder.id,
    ).watch(context);
    final pagesState = FolderTreeController.getPagesSignal(
      folder.id,
    ).watch(context);

    // Using context.colors to trigger repaint on theme change if needed by children
    // but the extracted widgets handle their own theme lookups.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FolderTile(
          folder: folder,
          isExpanded: isExpanded,
          onTap: () => FolderTreeController.toggleFolder(folder.id),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12.0), // Indentation
            child: Column(
              children: [
                // Display Subfolders
                childrenState.map(
                  data: (children) {
                    if (children.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: children
                          .map(
                            (child) =>
                                FolderTreeItem(folder: child, level: level + 1),
                          )
                          .toList(),
                    );
                  },
                  error: (_, _) => const SizedBox.shrink(),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                // Display Pages
                pagesState.map(
                  data: (pages) {
                    if (pages.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: pages
                          .map((page) => PageTile(page: page))
                          .toList(),
                    );
                  },
                  error: (_, _) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
