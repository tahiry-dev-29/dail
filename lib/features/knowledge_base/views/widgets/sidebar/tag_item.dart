import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/screens/tag_customization_screen.dart';
import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final TagEntity tag;

  const TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagColor = Color(int.parse(tag.color.replaceFirst('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        onTap: () => _showTagActionModal(context, tag, sl<TagViewModel>()),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tagColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: tagColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tag.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (tag.priority > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "P${tag.priority}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.accent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTagActionModal(
    BuildContext context,
    TagEntity tag,
    TagViewModel tagVM,
  ) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        borderRadius: 24,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(AppIcons.settings(context)),
              title: const Text("Modifier le Tag"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagCustomizationScreen(tag: tag),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(AppIcons.delete(context), color: colors.error),
              title: Text("Supprimer", style: TextStyle(color: colors.error)),
              onTap: () {
                tagVM.deleteTag(tag.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
