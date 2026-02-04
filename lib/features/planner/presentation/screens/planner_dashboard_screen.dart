import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/quick_add_task_overlay.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/active_tasks_list.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/planner_header.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/task_filter_bar.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

// Signals for local UI state
final isCompletedExpanded = signal(false);
final isIgnoredExpanded = signal(false);

class PlannerDashboardScreen extends HookWidget {
  const PlannerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    useEffect(() {
      final dispose = effect(() {
        if (sl<HomeViewModel>().isAddTaskVisible.value) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
      return dispose;
    }, [scrollController]);

    return Builder(
      builder: (context) {
        final taskListVM = sl<TaskListViewModel>();
        final filteredTasksAsync = taskListVM.filteredTasks.watch(context);
        final expandedCompleted = isCompletedExpanded.watch(context);

        return filteredTasksAsync.map(
          data: (tasks) {
            final activeTasks = tasks
                .where((t) => !t.isDone && !t.isIgnored)
                .toList();
            final completedTasks = tasks.where((t) => t.isDone).toList();
            final ignoredTasks = tasks
                .where((t) => !t.isDone && t.isIgnored)
                .toList();
            final isEmpty = tasks.isEmpty;

            return Stack(
              children: [
                Column(
                  children: [
                    // Header
                    const PlannerHeader(),

                    // Filter Bar
                    const TaskFilterBar(),

                    // Task List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => taskListVM.loadTasks(),
                        color: context.colors.accent,
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            if (isEmpty)
                              SliverToBoxAdapter(
                                child: EmptyStateWidget(
                                  title: "Journal de bord vide",
                                  subtitle:
                                      "Capturez une pensée ou planifiez une action pour commencer.",
                                  icon: AppIcons.calendar(context),
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
                                        onToggle: () =>
                                            taskListVM.toggleTask(task.id),
                                        onDelete: () =>
                                            taskListVM.deleteTask(task.id),
                                        onFavorite: () => taskListVM.updateTask(
                                          task.copyWith(
                                            isFavorite: !task.isFavorite,
                                          ),
                                        ),
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
                                        onToggle: () =>
                                            taskListVM.toggleTask(task.id),
                                        onDelete: () =>
                                            taskListVM.deleteTask(task.id),
                                        onFavorite: () => taskListVM.updateTask(
                                          task.copyWith(
                                            isFavorite: !task.isFavorite,
                                          ),
                                        ),
                                      );
                                    }, childCount: ignoredTasks.length),
                                  ),
                                ),
                            ],

                            const SliverToBoxAdapter(
                              child: SizedBox(height: 10),
                            ),

                            // Dynamic bottom spacer
                            SliverToBoxAdapter(
                              child: Watch((context) {
                                final isVisible = sl<HomeViewModel>()
                                    .isNavBarVisible
                                    .watch(context);
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
      },
    );
  }
}
