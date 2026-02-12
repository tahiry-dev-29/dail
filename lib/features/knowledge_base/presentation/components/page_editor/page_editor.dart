import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_list.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_header.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// Page editor that reacts to activePageId changes via Signals effect.
class PageEditor extends StatelessWidget {
  const PageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final activePageVM = sl<ActivePageViewModel>();
    final blockVM = sl<BlockViewModel>();

    // Trigger load is now handled by the ViewModel coordination or routing
    // But to be safe and reactive without StatefulWidget:
    // We can use a signal effect if we really need to, but ideally logic is in VM.
    // For now, let's assume WorkspaceScreen/ActivePageViewModel handles the 'setActive'
    // which should trigger the load.

    // Actually, looking at WorkspaceScreen, it calls `setActivePageId`.
    // We should ensure that SETTING the active page ID triggers the block load in the VM layer.

    final pageState = activePageVM.activePage.watch(context);

    return pageState.map(
      data: (page) {
        if (page == null) {
          final colors = context.colors;
          return Center(
            child: Text(
              'No page selected',
              style: context.bodyLarge.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          );
        }
        return _buildPageContent(context, page, blockVM);
      },
      error: (error, _) => Center(child: Text('Error loading page: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    PageEntity page,
    BlockViewModel blockVM,
  ) {
    return Watch((context) {
      // Watch the blocks state from ViewModel
      final blocksState = blockVM.blocks.value;

      return CustomScrollView(
        slivers: [
          // Page Header (Title, Cover, Icon)
          SliverToBoxAdapter(child: PageHeader(page: page)),

          blocksState.map(
            data: (blocks) {
              if (blocks.isEmpty) {
                final colors = context.colors;
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: GestureDetector(
                    onTap: () {
                      blockVM.addBlock(
                        BlockEntity.paragraph(id: Uuid().v4(), pageId: page.id),
                      );
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      alignment: .topCenter,
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Start typing...',
                        style: context.bodyMedium.copyWith(
                          color: colors.textSecondary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return BlockList(blocks: blocks.toList());
            },
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text('Error loading blocks: $e')),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      );
    });
  }
}
