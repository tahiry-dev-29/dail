import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/commands/slash_command_menu.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

class TextBlockHook extends HookWidget {
  final BlockEntity block;
  final TextStyle? style;

  const TextBlockHook({super.key, required this.block, this.style});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final layerLink = useMemoized(() => LayerLink());
    final focusNode = useFocusNode();
    final overlayEntry = useState<OverlayEntry?>(null);

    void hideCommandMenu() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    void handleCommandSelection(BlockType type) {
      // 1. Remove the '/' from current text
      String newText = block.text;
      if (newText.endsWith('/')) {
        newText = newText.substring(0, newText.length - 1);
      }

      // 2. Update current block
      blockVM.updateBlock(
        block.copyWith(content: {...block.content, 'text': newText}),
      );

      // 3. Create new block of selected type
      final newBlockId = const Uuid().v4();
      BlockEntity? newBlock;

      switch (type) {
        case BlockType.paragraph:
          newBlock = BlockEntity.paragraph(
            id: newBlockId,
            pageId: block.pageId,
          );
        case BlockType.heading1:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 1,
          );
        case BlockType.heading2:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 2,
          );
        case BlockType.heading3:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 3,
          );
        case BlockType.checklist:
          newBlock = BlockEntity.checklist(
            id: newBlockId,
            pageId: block.pageId,
          );
        case BlockType.image:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: BlockType.image,
          );
        case BlockType.code:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: BlockType.code,
          );
        case BlockType.divider:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: BlockType.divider,
          );
        case BlockType.quote:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: BlockType.quote,
          );
        case BlockType.audio:
          newBlock = BlockEntity.audio(
            id: newBlockId,
            pageId: block.pageId,
            path: '',
          );
      }

      blockVM.insertBlockAfter(block.id, newBlock);
    }

    void showCommandMenu() {
      if (overlayEntry.value != null) return;

      final overlay = Overlay.of(context);
      final entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: hideCommandMenu,
                behavior: HitTestBehavior.translucent,
              ),
            ),
            CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 30),
              child: Material(
                color: Colors.transparent,
                child: SlashCommandMenu(
                  onSelect: (type) {
                    handleCommandSelection(type);
                    hideCommandMenu();
                  },
                ),
              ),
            ),
          ],
        ),
      );

      overlayEntry.value = entry;
      overlay.insert(entry);
    }

    // Effect to clean up overlay on unmount
    useEffect(() => hideCommandMenu, const []);

    final baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5);

    return CompositedTransformTarget(
      link: layerLink,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: TextFormField(
          focusNode: focusNode,
          initialValue: block.text,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          style: baseStyle?.copyWith(color: colors.textPrimary),
          maxLines: null,
          onChanged: (value) {
            if (value.endsWith('/')) {
              showCommandMenu();
            } else {
              hideCommandMenu();
            }

            blockVM.updateBlock(
              block.copyWith(content: {...block.content, 'text': value}),
            );
          },
        ),
      ),
    );
  }
}
