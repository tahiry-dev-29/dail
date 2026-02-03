import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/checklist_block.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/code_block.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/divider_block.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/image_block.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/quote_block.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/blocks/text_block.dart';
import 'package:flutter/material.dart';

/// Dispatcher widget that renders the appropriate block based on type.
/// Adheres to the 200-line rule by delegating specialized logic to sub-widgets.
class BlockWidget extends StatelessWidget {
  final BlockEntity block;
  final bool isSelected;
  final VoidCallback? onFocus;

  const BlockWidget({
    super.key,
    required this.block,
    this.isSelected = false,
    this.onFocus,
  });

  @override
  Widget build(BuildContext context) {
    return switch (block.type) {
      .paragraph => TextBlockHook(block: block),
      .heading1 => TextBlockHook(
        block: block,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      .heading2 => TextBlockHook(
        block: block,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      .heading3 => TextBlockHook(
        block: block,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      .checklist => ChecklistBlock(block: block),
      .image => ImageBlock(block: block),
      .code => CodeBlock(block: block),
      .divider => DividerBlock(block: block),
      .quote => QuoteBlock(block: block),
    };
  }
}
