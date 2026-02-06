import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/markdown_editor/formatting_toolbar.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_list.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_header.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MarkdownNoteEditor extends HookWidget {
  final PageEntity page;

  const MarkdownNoteEditor({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final blockVM = sl<BlockViewModel>();
    final blocksState = blockVM.blocks.watch(context);

    // Load blocks when the page changes
    useEffect(() {
      blockVM.loadBlocks(page.id);
      return null;
    }, [page.id]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Page Header (Title, Icon, Cover)
              SliverToBoxAdapter(child: PageHeader(page: page)),

              // Dynamic Block List
              blocksState.map(
                data: (blocks) {
                  if (blocks.isEmpty) {
                    final colors = Theme.of(context).colorScheme;
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: GestureDetector(
                        onTap: () {
                          blockVM.addBlock(
                            BlockEntity.paragraph(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              pageId: page.id,
                            ),
                          );
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 50,
                            right: 50,
                          ),
                          child: Text(
                            'Commencer à écrire...',
                            style: TextStyle(
                              color: colors.onSurface.withValues(alpha: 0.3),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return BlockList(blocks: blocks);
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(
                  child: Center(child: Text('Error loading blocks: $e')),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 150)),
            ],
          ),

          // Floating Toolbar at bottom
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: const Center(child: FormattingToolbar()),
          ),
        ],
      ),
    );
  }
}
