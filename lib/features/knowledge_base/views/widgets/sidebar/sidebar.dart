import 'dart:ui' as ui;

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/sidebar_signals.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/folder_tree_item.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_favorites_section.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_footer.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_primary_nav.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_section_label.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar_workspace_header.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

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

    // Watch expand signals
    final isTagsExp = isTagsExpandedSignal.watch(context);
    final isFoldersExp = isFoldersExpandedSignal.watch(context);

    // According to Material Design guidelines, a standard drawer on mobile is usually 304dp.
    // However, since this widget can be placed inside a Drawer or be part of a split view,
    // we use a constrained layout allowing it to define its own width based on its container,
    // or fallback to a standard width if unconstrained.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
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
                SidebarWorkspaceHeader(activeWorkspace: activeWorkspace),
                const SidebarPrimaryNav(),
                const SizedBox(height: 24),
                Expanded(
                  child: RepaintBoundary(
                    child: CustomScrollView(
                      slivers: [
                        SidebarFavoritesSection(
                          activeWorkspace: activeWorkspace,
                        ),
                        SidebarSectionLabel(
                          label: 'PRIVATE',
                          isExpanded: isFoldersExp,
                          onToggle: () =>
                              isFoldersExpandedSignal.value = !isFoldersExp,
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
                        SidebarSectionLabel(
                          label: 'TAGS',
                          isExpanded: isTagsExp,
                          onToggle: () =>
                              isTagsExpandedSignal.value = !isTagsExp,
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
                                  return TagItem(tag: sortedTags[index]);
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
                ),
                SidebarFooter(
                  workspaceVM: workspaceVM,
                  folderTreeVM: folderTreeVM,
                  tagVM: tagVM,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
