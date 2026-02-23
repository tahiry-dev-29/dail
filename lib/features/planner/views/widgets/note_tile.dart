import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:flutter/material.dart';

/// A single note row: emoji icon + title + chevron.
class NoteTile extends StatelessWidget {
  final PageEntity note;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    this.onFavorite,
  });

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
            if (onFavorite != null)
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  note.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 16,
                  color: note.isFavorite
                      ? colors.accent
                      : colors.textSecondary.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                splashRadius: 16,
              )
            else
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
