import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_widget.dart';
import 'package:flutter/material.dart';

class BlockList extends StatelessWidget {
  final List<BlockEntity> blocks;

  const BlockList({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      itemCount: blocks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = blocks.removeAt(oldIndex);
        blocks.insert(newIndex, item);

        // Extract IDs for controller update
        final newOrderIds = blocks.map((b) => b.id).toList();
        BlockController.reorderBlocks(newOrderIds);
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

class _BuildBlockItem extends StatefulWidget {
  final BlockEntity block;
  const _BuildBlockItem({required this.block});

  @override
  State<_BuildBlockItem> createState() => _BuildBlockItemState();
}

class _BuildBlockItemState extends State<_BuildBlockItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 2.0),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            // Handle / Drag Grip
            Opacity(
              opacity: _isHovered ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Icon(
                  Icons.drag_indicator,
                  size: 20,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(child: BlockWidget(block: widget.block)),
          ],
        ),
      ),
    );
  }
}
