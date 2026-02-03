import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_controller.dart';
import 'package:flutter/material.dart';

class PageTile extends StatelessWidget {
  final PageEntity page;

  const PageTile({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () {
        // Handle page selection
        ActivePageController.selectPage(page.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          children: [
            Hero(
              tag: 'page-icon-${page.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  page.iconEmoji.isEmpty ? '📄' : page.iconEmoji,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                page.title,
                style: TextStyle(color: colors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
