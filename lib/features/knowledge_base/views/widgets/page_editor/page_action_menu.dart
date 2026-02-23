import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class PageActionMenu extends StatelessWidget {
  final PageEntity page;

  const PageActionMenu({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activePageVM = sl<ActivePageViewModel>();
    final workspaceVM = sl<WorkspaceViewModel>();

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: colors.textSecondary),
      offset: const Offset(0, 40),
      color: Colors.transparent,
      elevation: 0,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'favorite',
          child: _BuildMenuItem(
            icon: page.isFavorite ? Icons.star : Icons.star_border,
            label: page.isFavorite
                ? 'Retirer des favoris'
                : 'Ajouter aux favoris',
            iconColor: page.isFavorite ? Colors.amber : colors.textPrimary,
          ),
        ),
        PopupMenuItem(
          value: 'move',
          child: _BuildMenuItem(
            icon: Icons.drive_file_move_outlined,
            label: 'Déplacer vers...',
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: _BuildMenuItem(
            icon: Icons.delete_outline,
            label: 'Supprimer',
            iconColor: colors.error,
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'favorite':
            activePageVM.toggleFavorite();
            break;
          case 'move':
            _showFolderPicker(context, workspaceVM, activePageVM, page);
            break;
          case 'delete':
            _confirmDelete(context, activePageVM, workspaceVM, page);
            break;
        }
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ActivePageViewModel activePageVM,
    WorkspaceViewModel workspaceVM,
    PageEntity page,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await activePageVM.deletePage(page.id);
              workspaceVM.showDashboard();
              if (context.mounted) {
                ToastService.show(context, message: 'Note supprimée');
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFolderPicker(
    BuildContext context,
    WorkspaceViewModel workspaceVM,
    ActivePageViewModel activePageVM,
    PageEntity page,
  ) {
    // We'll implement a simple folder picker here
    // For now, just a toast to confirm intent
    ToastService.show(context, message: 'Déplacement bientôt disponible');
  }
}

class _BuildMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _BuildMenuItem({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, color: iconColor ?? colors.textPrimary, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: iconColor ?? colors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
