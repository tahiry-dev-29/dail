import 'dart:async';

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/commands/slash_command_menu.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextBlockHook extends HookWidget {
  final BlockEntity block;
  final TextStyle? style;

  const TextBlockHook({super.key, required this.block, this.style});

  @override
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final layerLink = useMemoized(() => LayerLink());
    final focusNode = useFocusNode();
    final overlayEntry = useState<OverlayEntry?>(null);
    final controller = useTextEditingController(text: block.text);
    final debounceTimer = useRef<Timer?>(null);

    // Track focus
    useEffect(() {
      void listener() {
        if (focusNode.hasFocus) {
          blockVM.setFocusedBlockId(block.id);
        } else if (blockVM.focusedBlockId.value == block.id) {
          blockVM.setFocusedBlockId(null);
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [block.id]);

    // Sync controller if block text changes externally (optional, strictly for fresh loads)
    // We avoid aggressive syncing to prevent cursor jumps while typing.
    useEffect(() {
      if (controller.text != block.text && !focusNode.hasFocus) {
        controller.text = block.text;
      }
      return null;
    }, [block.text]);

    void hideCommandMenu() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    void handleCommandSelection(BlockType type) {
      // 1. Remove the '/' from current text
      String newText = controller.text;
      if (newText.endsWith('/')) {
        newText = newText.substring(0, newText.length - 1);
      }

      // 2. Perform conversion (Update current block type and text)
      // This preserves ID and position.
      BlockEntity updatedBlock;

      switch (type) {
        case BlockType.paragraph:
          updatedBlock = block.copyWith(
            type: BlockType.paragraph,
            content: {...block.content, 'text': newText},
          );
        case BlockType.heading1:
          updatedBlock = block.copyWith(
            type: BlockType.heading1,
            content: {...block.content, 'text': newText},
          );
        case BlockType.heading2:
          updatedBlock = block.copyWith(
            type: BlockType.heading2,
            content: {...block.content, 'text': newText},
          );
        case BlockType.heading3:
          updatedBlock = block.copyWith(
            type: BlockType.heading3,
            content: {...block.content, 'text': newText},
          );
        case BlockType.checklist:
          // Convert text to first item of checklist
          updatedBlock = BlockEntity.checklist(
            id: block.id,
            pageId: block.pageId,
            items: [
              {'text': newText, 'checked': false},
            ],
            sortOrder: block.sortOrder,
          );
        case BlockType.quote:
          updatedBlock = block.copyWith(
            type: BlockType.quote,
            content: {...block.content, 'text': newText},
          );
        case BlockType.code:
          updatedBlock = block.copyWith(
            type: BlockType.code,
            content: {'code': newText, 'language': 'dart'},
          );
        case BlockType.divider:
          // For non-text blocks, we might want to insert instead?
          // Or strictly convert. Let's convert for now.
          updatedBlock = BlockEntity(
            id: block.id,
            pageId: block.pageId,
            type: BlockType.divider,
            sortOrder: block.sortOrder,
          );
        case BlockType.image:
          updatedBlock = BlockEntity(
            id: block.id,
            pageId: block.pageId,
            type: BlockType.image,
            sortOrder: block.sortOrder,
          );
        case BlockType.audio:
          updatedBlock = BlockEntity.audio(
            id: block.id,
            pageId: block.pageId,
            path: '',
            sortOrder: block.sortOrder,
          );
      }

      blockVM.updateBlock(updatedBlock);

      // Update controller text to match cleaned text (no slash)
      controller.text = newText;
      // Focus remains because we didn't unmount the widget (hopefully).
      focusNode.requestFocus();
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
                child: Container(color: Colors.transparent),
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

    // Effect to clean up overlay AND timer on unmount
    useEffect(
      () => () {
        hideCommandMenu();
        debounceTimer.value?.cancel();
      },
      const [],
    );

    final baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5);

    return CompositedTransformTarget(
      link: layerLink,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: TextFormField(
          controller: controller, // Use controller
          focusNode: focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'Write something... (Type / for commands)',
            hintStyle: baseStyle?.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          style: baseStyle?.copyWith(color: colors.textPrimary),
          maxLines: null,
          onChanged: (value) {
            if (value.endsWith('/')) {
              showCommandMenu();
            } else {
              hideCommandMenu();
            }

            // Debounce save to avoid heavy Isar transactions on every keystroke
            debounceTimer.value?.cancel();
            debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
              blockVM.updateBlock(
                block.copyWith(content: {...block.content, 'text': value}),
              );
            });
          },
        ),
      ),
    );
  }
}
