import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_widget.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BlockList extends StatelessWidget {
  final List<BlockEntity> blocks;

  const BlockList({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    final blockVM = sl<BlockViewModel>();

    return SliverReorderableList(
      itemCount: blocks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final reorderedBlocks = List<BlockEntity>.from(blocks);
        final item = reorderedBlocks.removeAt(oldIndex);
        reorderedBlocks.insert(newIndex, item);

        // Extract IDs for ViewModel update
        final newOrderIds = reorderedBlocks.map((b) => b.id).toList();
        blockVM.reorderBlocks(newOrderIds);
      },
      itemBuilder: (context, index) {
        final block = blocks[index];
        return ReorderableDragStartListener(
          key: ValueKey(block.id),
          index: index,
          child: _BuildBlockItem(block: block),
        );
      },
    );
  }
}

class _BuildBlockItem extends HookWidget {
  final BlockEntity block;
  const _BuildBlockItem({required this.block});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final colors = context.colors;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle / Drag Grip
            Opacity(
              opacity: isHovered.value ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Icon(
                  Icons.drag_indicator,
                  size: 20,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(child: BlockWidget(block: block)),
          ],
        ),
      ),
    );
  }
}
