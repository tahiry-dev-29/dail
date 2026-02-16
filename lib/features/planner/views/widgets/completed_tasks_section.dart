import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/views/widgets/task_list/task_tile.dart';
import 'package:daily_os/features/planner/views/bloc/task_provider.dart';
import 'package:daily_os/features/planner/views/widgets/section_helpers.dart';
import 'package:daily_os/design_system/organisms/expandable_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sliver section for completed tasks with drag-and-drop support.
class CompletedTasksSection extends ConsumerWidget {
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;
  final void Function(String id) onFavorite;

  const CompletedTasksSection({
    super.key,
    required this.onToggle,
    required this.onDelete,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(completedTasksProvider);

    return tasksState.when(
      data: (tasks) {
        if (tasks.isEmpty) return const SliverToBoxAdapter();

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: ExpandableSection(
                title: 'TERMINÉ',
                icon: Icons.task_alt_rounded,
                isInitialExpanded: false,
                trailing: CountBadge(count: tasks.length, isAccent: false),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
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
                          onTap: () =>
                              sl<WorkspaceViewModel>().selectTask(task.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SliverToBoxAdapter(),
      error: (err, stack) => const SliverToBoxAdapter(),
    );
  }
}
