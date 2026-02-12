import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/block_widget.dart';
import 'package:flutter/material.dart';

class BlockList extends StatelessWidget {
  final List<BlockEntity> blocks;

  const BlockList({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        return _BuildBlockItem(
          key: ValueKey(block.id),
          block: block,
          index: index,
        );
      },
    );
  }
}

/// Surgical Signal for hover state — no StatefulWidget needed.
class _BuildBlockItem extends StatelessWidget {
  final BlockEntity block;
  final int index;

  const _BuildBlockItem({super.key, required this.block, required this.index});

  @override
  Widget build(BuildContext context) {
    // No hover state needed for drag handle anymore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 2.0),
      child: BlockWidget(block: block),
    );
  }
}
