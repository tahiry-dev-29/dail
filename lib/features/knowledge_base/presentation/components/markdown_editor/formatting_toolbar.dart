import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FormattingToolbar extends StatelessWidget {
  const FormattingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final focusedId = blockVM.focusedBlockId.watch(context);

    if (focusedId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: colors.surface.withValues(alpha: 0.9),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToolbarButton(
                  icon: Icons.title,
                  label: 'H1',
                  onPressed: () =>
                      _updateBlockType(focusedId, BlockType.heading1),
                ),
                _ToolbarButton(
                  icon: Icons.text_fields,
                  label: 'H2',
                  onPressed: () =>
                      _updateBlockType(focusedId, BlockType.heading2),
                ),
                _ToolbarButton(
                  icon: Icons.check_box_outlined,
                  onPressed: () =>
                      _updateBlockType(focusedId, BlockType.checklist),
                ),
                VerticalDivider(
                  indent: 12,
                  endIndent: 12,
                  color: colors.textSecondary.withValues(alpha: 0.2),
                ),
                _ToolbarButton(
                  icon: Icons.format_bold,
                  onPressed: () => _applyFormatting(focusedId, '**'),
                ),
                _ToolbarButton(
                  icon: Icons.format_italic,
                  onPressed: () => _applyFormatting(focusedId, '*'),
                ),
                _ToolbarButton(
                  icon: Icons.format_list_bulleted,
                  onPressed: () => _updateBlockType(
                    focusedId,
                    BlockType.paragraph,
                  ), // Default / Bullet logic can be added
                ),
                _ToolbarButton(
                  icon: Icons.format_quote,
                  onPressed: () => _updateBlockType(focusedId, BlockType.quote),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateBlockType(String id, BlockType type) {
    final blockVM = sl<BlockViewModel>();
    final currentBlocks = blockVM.blocks.value.value ?? [];
    final block = currentBlocks.firstWhere((b) => b.id == id);

    // Simple conversion logic (similar to slash menu)
    blockVM.updateBlock(block.copyWith(type: type));
  }

  void _applyFormatting(String id, String symbol) {
    // This requires text selection awareness which is hard with current architecture
    // For now, we wrap the whole text or just append?
    // Let's at least try to append if we can't get selection easily.
    final blockVM = sl<BlockViewModel>();
    final currentBlocks = blockVM.blocks.value.value ?? [];
    final block = currentBlocks.firstWhere((b) => b.id == id);
    final currentText = block.text;

    blockVM.updateBlock(
      block.copyWith(
        content: {...block.content, 'text': '$symbol$currentText$symbol'},
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IconButton(
      icon: label != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16),
                Text(label!, style: const TextStyle(fontSize: 8)),
              ],
            )
          : Icon(icon, size: 20),
      onPressed: onPressed,
      color: colors.textPrimary,
      splashRadius: 20,
    );
  }
}
