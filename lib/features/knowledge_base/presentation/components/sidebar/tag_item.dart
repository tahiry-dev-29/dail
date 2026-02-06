import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final TagEntity tag;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TagItem({super.key, required this.tag, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Parse hex color string to Color
    Color tagColor;
    try {
      tagColor = Color(int.parse(tag.color.replaceAll('#', '0xFF')));
    } catch (_) {
      tagColor = colors.textSecondary;
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: tagColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tag.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
