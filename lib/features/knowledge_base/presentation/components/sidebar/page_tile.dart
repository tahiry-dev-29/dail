import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PageTile extends StatelessWidget {
  final PageEntity page;

  const PageTile({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activePageId = sl<ActivePageViewModel>().activePageId.watch(context);
    final isSelected = activePageId == page.id;

    return InkWell(
      onTap: () {
        sl<ActivePageViewModel>().setActivePageId(page.id);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
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
                page.title.isEmpty ? 'Untitled' : page.title,
                style: context.bodyMedium.copyWith(
                  color: isSelected ? colors.accent : colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
