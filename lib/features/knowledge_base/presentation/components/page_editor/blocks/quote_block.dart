import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';

class QuoteBlock extends StatelessWidget {
  final BlockEntity block;

  const QuoteBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final text = block.text;

    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: colors.accent, width: 3)),
      ),
      child: TextFormField(
        initialValue: text,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Empty quote',
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colors.textPrimary,
          fontStyle: FontStyle.italic,
        ),
        maxLines: null,
        onChanged: (value) {
          blockVM.updateBlock(
            block.copyWith(content: {...block.content, 'text': value}),
          );
        },
      ),
    );
  }
}
