import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:flutter/material.dart';

class SidebarFavoritePageTile extends StatelessWidget {
  final PageEntity page;

  const SidebarFavoritePageTile({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        onTap: () {
          workspaceVM.selectNote(page.id);
          sl<HomeViewModel>().switchTab(AppTabs.workspace.index);
          if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Text(page.iconEmoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  page.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 12, color: Colors.amber.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
