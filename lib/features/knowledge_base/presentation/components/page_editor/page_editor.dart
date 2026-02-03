import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_state.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_list.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_header.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PageEditor extends StatefulWidget {
  const PageEditor({super.key});

  @override
  State<PageEditor> createState() => _PageEditorState();
}

class _PageEditorState extends State<PageEditor> {
  @override
  void initState() {
    super.initState();
    // Initialize signals
    ActivePageController.init();
    BlockController.init();
  }

  // Clean up if needed, though signals usually persist or handle their own disposal
  @override
  void dispose() {
    // We don't dispose the controllers here as they might be singletons or app-scoped
    // But if they are screen-scoped, we might need a dispose method.
    // Given the current implementation in logic layer, they are static/global.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageState = activePageSignal.watch(context);

    return pageState.map(
      data: (page) {
        if (page == null) {
          return Center(
            child: Text(
              'No page selected',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          );
        }
        return _buildPageContent(context, page);
      },
      error: (error, _) => Center(child: Text('Error loading page: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPageContent(BuildContext context, PageEntity page) {
    final blocksState = blocksSignal.watch(context);

    return CustomScrollView(
      slivers: [
        // Page Header (Title, Cover, Icon)
        // Page Header (Title, Cover, Icon)
        SliverToBoxAdapter(child: PageHeader(page: page)),

        blocksState.map(
          data: (blocks) {
            if (blocks.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text('Start typing...')),
              );
            }
            // Passing a mutable copy to allow local reordering inside the widget before signal update
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
  }
}
