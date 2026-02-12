import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:flutter/material.dart';

/// A single note row: emoji icon + title + chevron.
class NoteTile extends StatelessWidget {
  final PageEntity note;
  final VoidCallback onTap;

  const NoteTile({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Text(note.iconEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                note.title,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: colors.textSecondary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
