import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:flutter/material.dart';

class ChecklistBlock extends StatelessWidget {
  final BlockEntity block;

  const ChecklistBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = block.checklistItems;

    // If empty checklist, show at least one item
    if (items.isEmpty) {
      // This should theoretically be handled by controller init, but safe guard.
      return const SizedBox.shrink();
    }

    // For now, handling single-item block model (One block = One checklist item usually in Notion-like apps,
    // but the entity suggests a list of items inside one block?
    // Let's check the entity structure: "checklist: {'items': [{'text': 'Item 1', 'checked': false}, ...]}"
    // If we support multiple items per block, we render a column.

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isChecked = item['checked'] as bool? ?? false;
        final text = item['text'] as String? ?? '';

        return Row(
          crossAxisAlignment: .start, // Align top for multiline
          children: [
            GestureDetector(
              onTap: () {
                final newItems = List<Map<String, dynamic>>.from(items);
                newItems[index] = {...item, 'checked': !isChecked};
                BlockController.updateBlock(
                  block.copyWith(
                    content: {...block.content, 'items': newItems},
                  ),
                );
              },
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
                  border: .none,
                  isDense: true,
                  contentPadding: .zero,
                ),
                style: TextStyle(
                  color: isChecked ? colors.textSecondary : colors.textPrimary,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
                maxLines: null,
                onChanged: (value) {
                  final newItems = List<Map<String, dynamic>>.from(items);
                  newItems[index] = {...item, 'text': value};
                  BlockController.updateBlock(
                    block.copyWith(
                      content: {...block.content, 'items': newItems},
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
