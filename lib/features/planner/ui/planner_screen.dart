import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import 'widgets/task_list_item.dart';
import 'widgets/add_task_inline.dart';
import 'widgets/empty_task_state.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../../shared/utils/toast_service.dart';

import 'package:daily_os/core/theme/adaptive_colors.dart';

// Signal for completed section expansion (local UI state)
final isCompletedExpanded = signal(false);
// Signal for ignored section expansion (local UI state)
final isIgnoredExpanded = signal(false);

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  Future<void> _onRefresh(WidgetRef ref) async {
    await ref.read(taskProvider.notifier).refreshTasks();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use computed providers (performance optimized)
    final activeTasks = ref.watch(activeTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);
    final ignoredTasks = ref.watch(ignoredTasksProvider);
    final selectedDate = calendarState.selectedDate.watch(context);
    final expandedCompleted = isCompletedExpanded.watch(context);
    final expandedIgnored = isIgnoredExpanded.watch(context);

    final isEmpty =
        activeTasks.isEmpty && completedTasks.isEmpty && ignoredTasks.isEmpty;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timeline',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy', 'fr_FR').format(selectedDate),
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Refresh Button
              GestureDetector(
                onTap: () => _onRefresh(ref),
                child: GlassContainer(
                  borderRadius: 50,
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    FontAwesomeIcons.arrowsRotate,
                    color: context.colors.textSecondary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Task List with Pull-to-Refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(ref),
            color: Colors.blueAccent,
            backgroundColor: Colors.grey[900],
            child: isEmpty
                ? ListView(children: const [EmptyTaskState()])
                : CustomScrollView(
                    slivers: [
                      // Active Tasks (Reorderable)
                      SliverReorderableList(
                        itemCount: activeTasks.length,
                        onReorder: (oldIndex, newIndex) {
                          ref
                              .read(taskProvider.notifier)
                              .reorderTasks(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final task = activeTasks[index];
                          // Backgrounds for swipes
                          final nestBg = Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            color: Colors.transparent,
                            child: Icon(
                              FontAwesomeIcons.indent,
                              color: context.colors.accent,
                              size: 20,
                            ),
                          );
                          final doneBg = Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.transparent,
                            child: const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.green,
                              size: 20,
                            ),
                          );

                          return ReorderableDragStartListener(
                            key: Key(task.id),
                            index: index,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 4.0,
                              ),
                              child: Dismissible(
                                key: Key('dismiss_${task.id}'),
                                // StartToEnd -> Nest (Right Swipe)
                                // EndToStart -> Done (Left Swipe)
                                direction: DismissDirection.horizontal,
                                dismissThresholds: const {
                                  DismissDirection.startToEnd: 0.2,
                                  DismissDirection.endToStart: 0.2,
                                },
                                background: nestBg,
                                secondaryBackground: doneBg,
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    // Right Swipe -> Nest (Demote)
                                    if (index == 0) {
                                      ToastService.warning(
                                        context,
                                        'Impossible de nester la première tâche',
                                      );
                                      return false;
                                    }
                                    ref
                                        .read(taskProvider.notifier)
                                        .demoteTask(
                                          task.id,
                                          targetParentId:
                                              activeTasks[index - 1].id,
                                        );
                                    ToastService.success(
                                      context,
                                      '📂 "${task.name}" imbriquée sous "${activeTasks[index - 1].name}"',
                                    );
                                    return true; // Visual dismiss, moves to subtask
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    // Left Swipe -> Done
                                    ref
                                        .read(taskProvider.notifier)
                                        .toggleTask(task.id);
                                    ToastService.success(
                                      context,
                                      '✨ "${task.name}" terminée !',
                                    );
                                    return true;
                                  }
                                  return false;
                                },
                                child: TaskListItem(
                                  task: task,
                                  onToggle: () => ref
                                      .read(taskProvider.notifier)
                                      .toggleTask(task.id),
                                  onDelete: () => ref
                                      .read(taskProvider.notifier)
                                      .deleteTask(task.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Completed Header
                      if (completedTasks.isNotEmpty)
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () =>
                                isCompletedExpanded.value = !expandedCompleted,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    expandedCompleted
                                        ? FontAwesomeIcons.chevronDown
                                        : FontAwesomeIcons.chevronRight,
                                    color: context.colors.textSecondary,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Terminées (${completedTasks.length})',
                                    style: TextStyle(
                                      color: context.colors.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Completed Tasks List (Static)
                      if (expandedCompleted && completedTasks.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final task = completedTasks[index];
                              return TaskListItem(
                                task: task,
                                onToggle: () => ref
                                    .read(taskProvider.notifier)
                                    .toggleTask(task.id),
                                onDelete: () => ref
                                    .read(taskProvider.notifier)
                                    .deleteTask(task.id),
                              );
                            }, childCount: completedTasks.length),
                          ),
                        ),

                      // Ignored Header
                      if (ignoredTasks.isNotEmpty)
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () =>
                                isIgnoredExpanded.value = !expandedIgnored,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    expandedIgnored
                                        ? FontAwesomeIcons.chevronDown
                                        : FontAwesomeIcons.chevronRight,
                                    color: context.colors.textSecondary,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ignorées (${ignoredTasks.length})',
                                    style: TextStyle(
                                      color: context.colors.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Ignored Tasks List (Static)
                      if (expandedIgnored && ignoredTasks.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final task = ignoredTasks[index];
                              // Ignored tasks look like completed/standard tasks but maybe dimmed?
                              // For now using standard TaskListItem but you can un-ignore by swiping/tapping.
                              // BUT since it's a SliverList here, no swipe. Only tap to 'toggle' (which usually means complete).
                              // Let's assume toggle task still works (marks done -> moves to done).
                              // Or maybe un-ignore?
                              // User said: "Afficher comme le Termiees".
                              return TaskListItem(
                                task: task,
                                onToggle: () => ref
                                    .read(taskProvider.notifier)
                                    .toggleTask(
                                      task.id,
                                    ), // Can complete directly
                                onDelete: () => ref
                                    .read(taskProvider.notifier)
                                    .deleteTask(task.id),
                              );
                            }, childCount: ignoredTasks.length),
                          ),
                        ),

                      // Bottom Spacing
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
          ),
        ),

        // Inline Add Task (Bottom)
        const AddTaskInline(),

        // Safe area padding for bottom nav
        const SizedBox(height: 90),
      ],
    );
  }
}
