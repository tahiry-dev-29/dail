import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/quick_add_task_overlay.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/widgets/planner_header.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PlannerDashboardScreen extends StatefulWidget {
  const PlannerDashboardScreen({super.key});

  @override
  State<PlannerDashboardScreen> createState() => _PlannerDashboardScreenState();
}

class _PlannerDashboardScreenState extends State<PlannerDashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final isCompletedExpanded = signal(false);
  final isIgnoredExpanded = signal(false);

  @override
  void initState() {
    super.initState();
    effect(() {
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final state = plannerController.tasksSignal.value;
      final selectedDate = calendarState.selectedDate.value;
      final expandedCompleted = isCompletedExpanded.value;
      final expandedIgnored = isIgnoredExpanded.value;

      return state.map(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(child: Text('Error: $error')),
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

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: PlannerHeader()),

                  if (tasksForDate.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text("Pas de tâches pour aujourd'hui"),
                      ),
                    ),

                  // Active Tasks Section
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TaskTile(
                          task: activeTasks[index],
                          onToggle: () => plannerController.toggleTask(
                            activeTasks[index].id,
                          ),
                          onDelete: () => plannerController.deleteTask(
                            activeTasks[index].id,
                          ),
                          onFavorite: () => {}, // TODO: Implement
                        ),
                        childCount: activeTasks.length,
                      ),
                    ),
                  ),

                  // Completed Section
                  if (completedTasks.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Terminées',
                      completedTasks.length,
                      expandedCompleted,
                      () => isCompletedExpanded.value = !expandedCompleted,
                    ),
                    if (expandedCompleted)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => TaskTile(
                              task: completedTasks[index],
                              onToggle: () => plannerController.toggleTask(
                                completedTasks[index].id,
                              ),
                              onDelete: () => plannerController.deleteTask(
                                completedTasks[index].id,
                              ),
                              onFavorite: () => {},
                            ),
                            childCount: completedTasks.length,
                          ),
                        ),
                      ),
                  ],

                  // Ignored Section
                  if (ignoredTasks.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Ignorées',
                      ignoredTasks.length,
                      expandedIgnored,
                      () => isIgnoredExpanded.value = !expandedIgnored,
                    ),
                    if (expandedIgnored)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => TaskTile(
                              task: ignoredTasks[index],
                              onToggle: () => plannerController.toggleTask(
                                ignoredTasks[index].id,
                              ),
                              onDelete: () => plannerController.deleteTask(
                                ignoredTasks[index].id,
                              ),
                              onFavorite: () => {},
                            ),
                            childCount: ignoredTasks.length,
                          ),
                        ),
                      ),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              const QuickAddTaskOverlay(),
            ],
          );
        },
      );
    });
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            children: [
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: context.colors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '$title ($count)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
