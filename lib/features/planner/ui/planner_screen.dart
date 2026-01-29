import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:intl/intl.dart';

import 'package:daily_os/core/theme/adaptive_colors.dart';
import 'package:daily_os/features/planner/providers/task_selectors.dart';
import 'package:daily_os/features/planner/providers/task_provider.dart';
import 'package:daily_os/features/calendar/providers/calendar_provider.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:daily_os/shared/widgets/glass_container.dart';

import 'widgets/task_list_item.dart';
import 'widgets/active_tasks_list.dart';
import 'widgets/add_task_inline.dart';
import 'widgets/empty_task_state.dart';

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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Timeline',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        DateFormat('d MMMM yyyy', 'fr_FR').format(selectedDate),
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Refresh Button
              GestureDetector(
                onTap: () => _onRefresh(ref),
                child: GlassContainer(
                  borderRadius: 50,
                  padding: const EdgeInsets.all(8),
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
                      // Active Tasks (Extracted Micro-component)
                      const ActiveTasksList(),

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
        Watch((context) => SizedBox(height: isNavBarVisible.value ? 90 : 20)),
      ],
    );
  }
}
