import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';

/// Displays a checklist block as a static list of toggleable items.
class ChecklistBlock extends StatelessWidget {
  final BlockEntity block;

  const ChecklistBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final blockVM = sl<BlockViewModel>();
    final items = block.checklistItems;

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isChecked = item['checked'] as bool? ?? false;
        final text = item['text'] as String? ?? '';

        return _ChecklistItem(
          key: ValueKey(item['id'] as String),
          isChecked: isChecked,
          text: text,
          onToggle: () {
            final newItems = List<Map<String, dynamic>>.from(items);
            newItems[index] = {...item, 'checked': !isChecked};
            blockVM.updateBlock(
              block.copyWith(content: {...block.content, 'items': newItems}),
            );
          },
          onTextChanged: (value) {
            final newItems = List<Map<String, dynamic>>.from(items);
            newItems[index] = {...item, 'text': value};
            blockVM.updateBlock(
              block.copyWith(content: {...block.content, 'items': newItems}),
            );
          },
        );
      }).toList(),
    );
  }
}

/// A single checklist row: checkbox + text input.
class _ChecklistItem extends StatelessWidget {
  final bool isChecked;
  final String text;
  final VoidCallback onToggle;
  final ValueChanged<String> onTextChanged;

  const _ChecklistItem({
    super.key,
    required this.isChecked,
    required this.text,
    required this.onToggle,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 8.0),
            child: Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: isChecked ? colors.accent : colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            initialValue: text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              color: isChecked ? colors.textSecondary : colors.textPrimary,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
            maxLines: null,
            onChanged: onTextChanged,
          ),
        ),
      ],
    );
  }
}
