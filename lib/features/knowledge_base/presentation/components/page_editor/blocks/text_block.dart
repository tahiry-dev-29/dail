import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/commands/slash_command_menu.dart';
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
    final layerLink = useMemoized(() => LayerLink());
    final focusNode = useFocusNode();
    final overlayEntry = useState<OverlayEntry?>(null);

    // Initial value for synchronization if needed, but TextFormField initialValue is usually enough
    // for local editing.

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
      BlockController.updateBlock(
        block.copyWith(content: {...block.content, 'text': newText}),
      );

      // 3. Create new block of selected type
      final newBlockId = const Uuid().v4();
      BlockEntity? newBlock;

      switch (type) {
        case .paragraph:
          newBlock = BlockEntity.paragraph(
            id: newBlockId,
            pageId: block.pageId,
          );
        case .heading1:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 1,
          );
        case .heading2:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 2,
          );
        case .heading3:
          newBlock = BlockEntity.heading(
            id: newBlockId,
            pageId: block.pageId,
            level: 3,
          );
        case .checklist:
          newBlock = BlockEntity.checklist(
            id: newBlockId,
            pageId: block.pageId,
          );
        case .image:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: .image,
          );
        case .code:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: .code,
          );
        case .divider:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: .divider,
          );
        case .quote:
          newBlock = BlockEntity(
            id: newBlockId,
            pageId: block.pageId,
            type: .quote,
          );
      }

      BlockController.insertBlockAfter(block.id, newBlock);
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
                behavior: .translucent,
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
            border: .none,
            isDense: true,
            contentPadding: .zero,
          ),
          style: baseStyle?.copyWith(color: colors.textPrimary),
          maxLines: null,
          onChanged: (value) {
            if (value.endsWith('/')) {
              showCommandMenu();
            } else {
              hideCommandMenu();
            }

            BlockController.updateBlock(
              block.copyWith(content: {...block.content, 'text': value}),
            );
          },
        ),
      ),
    );
  }
}
