import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/active_tasks_list.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/add_task_inline.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';

// Signals for local UI state
final isCompletedExpanded = signal(false);
final isIgnoredExpanded = signal(false);

class PlannerDashboardScreen extends ConsumerStatefulWidget {
  const PlannerDashboardScreen({super.key});

  @override
  ConsumerState<PlannerDashboardScreen> createState() =>
      _PlannerDashboardScreenState();
}

class _PlannerDashboardScreenState
    extends ConsumerState<PlannerDashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  late final void Function() _disposeEffect;

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when Add Task becomes visible
    _disposeEffect = effect(() {
      if (isAddTaskVisible.value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _disposeEffect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskListAsync = ref.watch(taskListProvider);
    final selectedDate = calendarState.selectedDate.watch(context);
    final expandedCompleted = isCompletedExpanded.watch(context);

    return taskListAsync.when(
      data: (tasks) {
        // Date filtering: show only tasks for selectedDate
        final tasksForDate = tasks.where((t) {
          if (t.date == null) return true; // Tasks without date show always
          return t.date!.year == selectedDate.year &&
              t.date!.month == selectedDate.month &&
              t.date!.day == selectedDate.day;
        }).toList();

        final activeTasks = tasksForDate
            .where((t) => !t.isDone && !t.isIgnored)
            .toList();
        final completedTasks = tasksForDate.where((t) => t.isDone).toList();
        final ignoredTasks = tasksForDate
            .where((t) => !t.isDone && t.isIgnored)
            .toList();
        final isEmpty = tasksForDate.isEmpty;

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Timeline', style: context.h2),
                        Text(
                          DateFormat(
                            'd MMMM yyyy',
                            'fr_FR',
                          ).format(selectedDate),
                          style: context.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () =>
                        ref.read(taskListProvider.notifier).loadTasks(),
                    child: GlassCard(
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

            // Task List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(taskListProvider.notifier).loadTasks(),
                color: context.colors.accent,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text("Pas de tâches pour aujourd'hui"),
                          ),
                        ),
                      ),

                    // Active Tasks with reordering
                    ActiveTasksList(activeTasks: activeTasks),

                    // New Task Input (Contextual/End of Active List)
                    SliverToBoxAdapter(
                      child: Watch((context) {
                        final isVisible = isAddTaskVisible.watch(context);
                        final parentTask = parentTaskSignal.watch(context);
                        if (isVisible && parentTask == null) {
                          return const AddTaskInline();
                        }
                        return const SizedBox.shrink();
                      }),
                    ),

                    // Completed Section
                    if (completedTasks.isNotEmpty) ...[
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
                                  style: context.bodyMedium.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (expandedCompleted)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final task = completedTasks[index];
                              return TaskTile(
                                task: task,
                                onToggle: () => ref
                                    .read(taskListProvider.notifier)
                                    .toggleTask(task.id),
                                onDelete: () => ref
                                    .read(taskListProvider.notifier)
                                    .deleteTask(task.id),
                                onFavorite: () => ref
                                    .read(taskListProvider.notifier)
                                    .toggleFavorite(task.id),
                              );
                            }, childCount: completedTasks.length),
                          ),
                        ),
                    ],

                    // Ignored Section
                    if (ignoredTasks.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () => isIgnoredExpanded.value =
                              !isIgnoredExpanded.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isIgnoredExpanded.value
                                      ? FontAwesomeIcons.chevronDown
                                      : FontAwesomeIcons.chevronRight,
                                  color: context.colors.textSecondary,
                                  size: 12,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ignorées (${ignoredTasks.length})',
                                  style: context.bodyMedium.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isIgnoredExpanded.value)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final task = ignoredTasks[index];
                              return TaskTile(
                                task: task,
                                onToggle: () => ref
                                    .read(taskListProvider.notifier)
                                    .toggleTask(task.id),
                                onDelete: () => ref
                                    .read(taskListProvider.notifier)
                                    .deleteTask(task.id),
                                onFavorite: () => ref
                                    .read(taskListProvider.notifier)
                                    .toggleFavorite(task.id),
                              );
                            }, childCount: ignoredTasks.length),
                          ),
                        ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 10)),

                    // Dynamic bottom spacer for keyboard/navbar
                    SliverToBoxAdapter(
                      child: Watch((context) {
                        final isVisible = isNavBarVisible.watch(context);
                        return SizedBox(height: isVisible ? 100 : 20);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
