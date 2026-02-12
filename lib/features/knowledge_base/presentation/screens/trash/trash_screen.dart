import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/trash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashVM = sl<TrashViewModel>();
    final deletedFoldersState = trashVM.deletedFolders.watch(context);
    final deletedPagesState = trashVM.deletedPages.watch(context);
    final colors = context.colors;

    final deletedFolders = deletedFoldersState.value ?? [];
    final deletedPages = deletedPagesState.value ?? [];
    final isLoading =
        deletedFoldersState.isLoading || deletedPagesState.isLoading;

    return GlassScaffold(
      appBar: AppBar(
        title: Text(
          'Trash',
          style: context.h2.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft(context), color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (deletedFolders.isNotEmpty || deletedPages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (childContext) => AlertDialog(
                      title: const Text('Empty Trash?'),
                      content: const Text(
                        'This will permanently delete all items in the trash. This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(childContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            trashVM.emptyTrash();
                            Navigator.pop(childContext);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          child: const Text('Empty Trash'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  AppIcons.delete(context),
                  size: 16,
                  color: colors.error,
                ),
                label: Text(
                  'Empty Trash',
                  style: context.bodySmall.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: isLoading && deletedFolders.isEmpty && deletedPages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Folders Section
                if (deletedFolders.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Folders',
                        style: context.bodySmall.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: deletedFolders.length,
                    itemBuilder: (context, index) {
                      final folder = deletedFolders[index];
                      return _TrashItem(
                        icon: Text(
                          folder.iconEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: folder.name,
                        onRestore: () => trashVM.restoreFolder(folder.id),
                        onDelete: () =>
                            trashVM.permanentlyDeleteFolder(folder.id),
                      );
                    },
                  ),
                ],

                // Pages Section
                if (deletedPages.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Pages',
                        style: context.bodySmall.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: deletedPages.length,
                    itemBuilder: (context, index) {
                      final page = deletedPages[index];
                      return _TrashItem(
                        icon: Icon(
                          AppIcons.description(context),
                          size: 20,
                          color: colors.textSecondary,
                        ),
                        title: page.title,
                        onRestore: () => trashVM.restorePage(page.id),
                        onDelete: () => trashVM.permanentlyDeletePage(page.id),
                      );
                    },
                  ),
                ],

                // Empty State
                if (deletedFolders.isEmpty &&
                    deletedPages.isEmpty &&
                    !isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            AppIcons.delete(context),
                            size: 64,
                            color: colors.textSecondary.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Trash is empty',
                            style: context.bodyLarge.copyWith(
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _TrashItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _TrashItem({
    required this.icon,
    required this.title,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: .w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Actions
            ActionIcon(
              icon: AppIcons.refresh(context),
              onTap: onRestore,
              color: colors.accent,
              size: 18,
              padding: const EdgeInsets.all(8),
            ),
            ActionIcon(
              icon: AppIcons.delete(context),
              onTap: onDelete,
              color: colors.error,
              size: 18,
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
}
