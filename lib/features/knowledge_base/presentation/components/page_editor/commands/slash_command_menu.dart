import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:flutter/material.dart';

class SlashCommandMenu extends StatelessWidget {
  final Function(BlockType) onSelect;

  const SlashCommandMenu({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final commands = [
      (
        BlockType.paragraph,
        'Text',
        'Start writing with plain text.',
        Icons.notes,
      ),
      (
        BlockType.heading1,
        'Heading 1',
        'Big section heading.',
        Icons.looks_one,
      ),
      (
        BlockType.heading2,
        'Heading 2',
        'Medium section heading.',
        Icons.looks_two,
      ),
      (
        BlockType.heading3,
        'Heading 3',
        'Small section heading.',
        Icons.looks_3,
      ),
      (
        BlockType.checklist,
        'To-do list',
        'Track tasks with checkboxes.',
        Icons.check_box_outlined,
      ),
      (
        BlockType.image,
        'Image',
        'Upload or embed with a link.',
        Icons.image_outlined,
      ),
      (BlockType.code, 'Code', 'Capture a code snippet.', Icons.code),
      (
        BlockType.divider,
        'Divider',
        'Visually divide sections.',
        Icons.horizontal_rule,
      ),
    ];

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Container(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'BASIC BLOCKS',
                style: TextStyle(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: commands.length,
                itemBuilder: (context, index) {
                  final cmd = commands[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(cmd.$4, size: 18, color: colors.textPrimary),
                    ),
                    title: Text(
                      cmd.$2,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      cmd.$3,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () => onSelect(cmd.$1),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
