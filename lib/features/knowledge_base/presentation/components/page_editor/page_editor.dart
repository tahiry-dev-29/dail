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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PageEditor extends HookWidget {
  const PageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    // Get ViewModels from DI
    final activePageVM = sl<ActivePageViewModel>();
    final blockVM = sl<BlockViewModel>();

    // Watch the active page state
    final pageState = activePageVM.activePage.watch(context);

    // Trigger block loading when active page changes
    useEffect(() {
      final page = activePageVM.activePage.value.value;
      if (page != null) {
        blockVM.loadBlocks(page.id);
      } else {
        blockVM.clear();
      }
      return null;
    }, [activePageVM.activePageId.value]);

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
                        BlockEntity.paragraph(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          pageId: page.id,
                        ),
                      );
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      alignment: Alignment.topCenter,
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
