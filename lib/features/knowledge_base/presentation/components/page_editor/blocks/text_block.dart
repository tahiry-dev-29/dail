import 'dart:async';

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// TextBlock — surgical StatefulWidget for TextEditingController, FocusNode,
/// OverlayEntry, and debounce Timer lifecycle management.
class TextBlockComponent extends StatefulWidget {
  final BlockEntity block;
  final TextStyle? style;

  const TextBlockComponent({super.key, required this.block, this.style});

  @override
  State<TextBlockComponent> createState() => _TextBlockComponentState();
}

class _TextBlockComponentState extends State<TextBlockComponent> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final LayerLink _layerLink;
  final _showToolbar = signal(false);
  Timer? _debounceTimer;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.text);
    _focusNode = FocusNode();
    _layerLink = LayerLink();

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant TextBlockComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller text if block content changed externally
    if (oldWidget.block.text != widget.block.text &&
        _controller.text != widget.block.text) {
      _controller.text = widget.block.text;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _removeOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    _showToolbar.value = _focusNode.hasFocus;
    if (_focusNode.hasFocus) {
      _insertOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _insertOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -40),
          child: _buildFloatingToolbar(),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onContentChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      sl<BlockViewModel>().updateBlock(
        widget.block.copyWith(
          content: {...widget.block.content, 'text': value},
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        maxLines: null,
        style:
            widget.style ?? _textStyleForBlockType(context, widget.block.type),
        decoration: InputDecoration(
          hintText: _hintForBlockType(widget.block.type),
          hintStyle: TextStyle(
            color: colors.textSecondary.withValues(alpha: 0.3),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        onChanged: _onContentChanged,
      ),
    );
  }

  Widget _buildFloatingToolbar() {
    final themeColors = context.colors;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: themeColors.surfaceElevated,
      child: Row(
        mainAxisSize: .min,
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            onPressed: () {
              // Bold formatting
              _wrapSelection('**');
            },
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            onPressed: () {
              _wrapSelection('_');
            },
          ),
          _ToolbarButton(
            icon: Icons.format_strikethrough,
            onPressed: () {
              _wrapSelection('~~');
            },
          ),
          _ToolbarButton(
            icon: Icons.code,
            onPressed: () {
              _wrapSelection('`');
            },
          ),
        ],
      ),
    );
  }

  void _wrapSelection(String wrapper) {
    final text = _controller.text;
    final selection = _controller.selection;
    if (selection.isCollapsed) return;

    final selectedText = text.substring(selection.start, selection.end);
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$wrapper$selectedText$wrapper',
    );
    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(
      offset: selection.end + wrapper.length * 2,
    );
  }

  TextStyle _textStyleForBlockType(BuildContext context, BlockType type) {
    final colors = context.colors;
    switch (type) {
      case BlockType.heading1:
        return TextStyle(
          fontSize: 28,
          fontWeight: .bold,
          color: colors.textPrimary,
        );
      case BlockType.heading2:
        return TextStyle(
          fontSize: 22,
          fontWeight: .w600,
          color: colors.textPrimary,
        );
      case BlockType.heading3:
        return TextStyle(
          fontSize: 18,
          fontWeight: .w600,
          color: colors.textPrimary,
        );
      case BlockType.quote:
        return TextStyle(
          fontSize: 16,
          fontStyle: .italic,
          color: colors.textSecondary,
        );
      default:
        return TextStyle(fontSize: 16, height: 1.6, color: colors.textPrimary);
    }
  }

  String _hintForBlockType(BlockType type) {
    switch (type) {
      case BlockType.heading1:
        return 'Heading 1';
      case BlockType.heading2:
        return 'Heading 2';
      case BlockType.heading3:
        return 'Heading 3';
      case BlockType.quote:
        return 'Quote...';
      default:
        return 'Type something...';
    }
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 18, color: Colors.white),
      onPressed: onPressed,
      splashRadius: 16,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
