import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/sidebar.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/recent_list_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class KnowledgeBaseScreen extends HookWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // Initialize Workspaces
      sl<WorkspaceViewModel>().loadWorkspaces();
      // Pre-load tags and recent list
      sl<TagViewModel>().loadTags();
      sl<RecentListViewModel>().loadRecentPages();
      return null;
    }, []);

    // Use LayoutBuilder to determine if we're on mobile or desktop
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile breakpoint: 800px (tablet portrait/phones)
        final isMobile = constraints.maxWidth < 800;
        final colors = context.colors;

        return Scaffold(
          backgroundColor: colors.background,
          // Mobile: Show Drawer
          drawer: isMobile
              ? const SizedBox(
                  width: 280,
                  child: Drawer(child: KnowledgeBaseSidebar()),
                )
              : null,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: colors.surface,
                  title: Text(
                    'Knowledge Base',
                    style: context.h2.copyWith(color: colors.textPrimary),
                  ),
                  iconTheme: IconThemeData(color: colors.textPrimary),
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(color: colors.border, height: 1),
                  ),
                )
              : null,
          body: Row(
            children: [
              // Desktop: Show permanent sidebar
              if (!isMobile) ...[
                const SizedBox(width: 250, child: KnowledgeBaseSidebar()),
                VerticalDivider(width: 1, thickness: 1, color: colors.border),
              ],
              Expanded(
                child: Column(
                  children: [
                    // Desktop Header (Hidden on Mobile as it's in AppBar)
                    if (!isMobile)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              'Knowledge Base',
                              // Using H1 from AppTypography via extension
                              style: context.h1.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Expanded(child: PageEditor()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
