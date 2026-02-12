import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// CodeBlock — surgical StatefulWidget for FocusNode lifecycle.
class CodeBlockComponent extends StatefulWidget {
  final BlockEntity block;

  const CodeBlockComponent({super.key, required this.block});

  @override
  State<CodeBlockComponent> createState() => _CodeBlockComponentState();
}

class _CodeBlockComponentState extends State<CodeBlockComponent> {
  late final FocusNode _focusNode;
  final _isEditing = signal(false);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _isEditing.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final isEditing = _isEditing.watch(context);

    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.customSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditing
                  ? colors.accent.withValues(alpha: 0.5)
                  : colors.border.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Code Language Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.block.content['language'] as String? ?? 'code',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: .bold,
                    color: colors.accent,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Code Content (Editable TextField)
              TextField(
                focusNode: _focusNode,
                controller: TextEditingController(text: widget.block.text),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: colors.textPrimary,
                  height: 1.5,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: (value) {
                  blockVM.updateBlock(
                    widget.block.copyWith(
                      content: {...widget.block.content, 'text': value},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
