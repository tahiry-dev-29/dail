import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// FAB menu — local signal for expand state.
class FloatingActionMenu extends StatelessWidget {
  const FloatingActionMenu({super.key});

  /// Local signal for menu expanded state.
  static final _isExpanded = signal(false);

  @override
  Widget build(BuildContext context) {
    final homeVM = sl<HomeViewModel>();
    final currentTab = homeVM.currentTab.watch(context);
    final isExpanded = _isExpanded.watch(context);

    // Only show on Workspace tab
    if (currentTab != AppTabs.workspace.index) {
      return const SizedBox.shrink();
    }

    // Hide if add task overlay is visible
    final isAddTaskVisible = homeVM.isAddTaskVisible.watch(context);
    if (isAddTaskVisible) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final activePageVM = sl<ActivePageViewModel>();
    final taskListVM = sl<TaskListViewModel>();

    void toggle() {
      _isExpanded.value = !_isExpanded.value;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        children: [
          if (isExpanded) ...[
            _ActionButton(
              icon: Icons.note_add_outlined,
              onPressed: () async {
                _isExpanded.value = false;
                final folderId = taskListVM.selectedFolderId.value;

                if (folderId != null) {
                  await activePageVM.createNewPage(folderId);
                  if (context.mounted) {
                    final newId = activePageVM.activePageId.value;
                    if (newId != null) {
                      workspaceVM.selectNote(newId);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Veuillez sélectionner un dossier dans le sidebar pour créer une note',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              color: colors.accent,
            ),
            const SizedBox(height: 16),
            _ActionButton(
              icon: Icons.add_task_rounded,
              onPressed: () {
                _isExpanded.value = false;
                homeVM.isAddTaskVisible.value = true;
              },
              color: colors.accent,
            ),
            const SizedBox(height: 16),
          ],
          FloatingActionButton(
            onPressed: toggle,
            backgroundColor: colors.accent,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: AnimatedRotation(
              turns: isExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}
