import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/logic/trash_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/trash_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  void initState() {
    super.initState();
    TrashController.loadDeletedItems();
  }

  @override
  Widget build(BuildContext context) {
    final deletedFoldersState = deletedFoldersSignal.watch(context);
    final deletedPagesState = deletedPagesSignal.watch(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text(
          'Trash',
          style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                // Confirm dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Empty Trash?'),
                    content: const Text(
                      'This will permanently delete all items in the trash. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          TrashController.emptyTrash();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
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
                color: Theme.of(context).colorScheme.error,
              ),
              label: Text(
                'Empty Trash',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Folders Section
          if (deletedFoldersState.value?.isNotEmpty ?? false) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'Folders',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: deletedFoldersState.value!.length,
              itemBuilder: (context, index) {
                final folder = deletedFoldersState.value![index];
                return _TrashItem(
                  icon: Text(
                    folder.iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: folder.name,
                  onRestore: () => TrashController.restoreFolder(folder.id),
                  onDelete: () =>
                      TrashController.permanentlyDeleteFolder(folder.id),
                );
              },
            ),
          ],

          // Pages Section
          if (deletedPagesState.value?.isNotEmpty ?? false) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'Pages',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: deletedPagesState.value!.length,
              itemBuilder: (context, index) {
                final page = deletedPagesState.value![index];
                return _TrashItem(
                  icon: Icon(
                    AppIcons.description(context),
                    size: 20,
                    color: colors.textSecondary,
                  ),
                  title: page.title,
                  onRestore: () => TrashController.restorePage(page.id),
                  onDelete: () =>
                      TrashController.permanentlyDeletePage(page.id),
                );
              },
            ),
          ],

          // Empty State
          if ((deletedFoldersState.value?.isEmpty ?? true) &&
              (deletedPagesState.value?.isEmpty ?? true))
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcons.delete(context),
                      size: 64,
                      color: colors.textSecondary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Trash is empty',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 16,
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
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Actions
            ActionIcon(
              icon: AppIcons.refresh(context),
              onTap: onRestore,
              color: Colors.green,
              size: 18,
              padding: const EdgeInsets.all(8),
            ),
            ActionIcon(
              icon: AppIcons.delete(context),
              onTap: onDelete,
              color: Theme.of(context).colorScheme.error,
              size: 18,
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
}
