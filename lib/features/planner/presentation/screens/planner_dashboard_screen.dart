import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/quick_add_task_overlay.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/active_tasks_list.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/planner_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
        final tasksForDate = tasks.where((t) {
          if (t.date == null) return true;
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

        return Stack(
          children: [
            Column(
              children: [
                // Header
                const PlannerHeader(),

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

                        // Active Tasks
                        ActiveTasksList(activeTasks: activeTasks),

                        // Completed Section
                        if (completedTasks.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: GestureDetector(
                              onTap: () => isCompletedExpanded.value =
                                  !expandedCompleted,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      expandedCompleted
                                          ? AppIcons.chevronDown(context)
                                          : AppIcons.chevronRight(context),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
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
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isIgnoredExpanded.value
                                          ? AppIcons.chevronDown(context)
                                          : AppIcons.chevronRight(context),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
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

                        // Dynamic bottom spacer
                        SliverToBoxAdapter(
                          child: Watch((context) {
                            final isVisible = isNavBarVisible.watch(context);
                            return SizedBox(height: isVisible ? 120 : 40);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Focused Entry Overlay
            const QuickAddTaskOverlay(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
