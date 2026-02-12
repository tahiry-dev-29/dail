import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/state/task_provider.dart';
import 'package:daily_os/features/planner/presentation/widgets/section_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sliver section displaying active (non-done, non-expired) tasks.
class ActiveTasksSection extends ConsumerWidget {
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;
  final void Function(String id) onFavorite;

  const ActiveTasksSection({
    super.key,
    required this.onToggle,
    required this.onDelete,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(activeTasksProvider);

    return tasksState.when(
      data: (tasks) => SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: SectionHeader(
              icon: Icons.check_circle_outline_rounded,
              title: 'TÂCHES ACTIVES',
              trailing: CountBadge(count: tasks.length),
            ),
          ),
          if (tasks.isEmpty)
            const SliverToBoxAdapter(
              child: EmptySection(message: 'Aucune tâche active'),
            )
          else
            SliverReorderableList(
              itemCount: tasks.length,
              onReorder: (oldIndex, newIndex) => ref
                  .read(activeTasksProvider.notifier)
                  .reorder(oldIndex, newIndex),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ReorderableDelayedDragStartListener(
                  key: ValueKey(task.id),
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: TaskTile(
                      task: task,
                      onToggle: () => onToggle(task.id),
                      onDelete: () => onDelete(task.id),
                      onFavorite: () => onFavorite(task.id),
                      onTap: () => sl<WorkspaceViewModel>().selectTask(task.id),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Erreur de chargement des tâches : $err'),
        ),
      ),
    );
  }
}
