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

// Signal for completed section expansion (local UI state)
final isCompletedExpanded = signal(false);

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
    final selectedDate = calendarState.selectedDate.watch(context);
    final expanded = isCompletedExpanded.watch(context);

    final isEmpty = activeTasks.isEmpty && completedTasks.isEmpty;

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
                  const Text(
                    'Timeline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy', 'fr_FR').format(selectedDate),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Refresh Button
              GestureDetector(
                onTap: () => _onRefresh(ref),
                child: const GlassContainer(
                  borderRadius: 50,
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    FontAwesomeIcons.arrowsRotate,
                    color: Colors.white38,
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount:
                        activeTasks.length +
                        (completedTasks.isNotEmpty ? 1 : 0) +
                        (expanded ? completedTasks.length : 0) +
                        1, // +1 for bottom spacing
                    itemBuilder: (context, index) {
                      // Active Tasks
                      if (index < activeTasks.length) {
                        final task = activeTasks[index];
                        return TaskListItem(
                          task: task,
                          onToggle: () => ref
                              .read(taskProvider.notifier)
                              .toggleTask(task.id),
                          onDelete: () => ref
                              .read(taskProvider.notifier)
                              .deleteTask(task.id),
                        );
                      }

                      // Completed Header
                      if (index == activeTasks.length &&
                          completedTasks.isNotEmpty) {
                        return GestureDetector(
                          onTap: () => isCompletedExpanded.value = !expanded,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  expanded
                                      ? FontAwesomeIcons.chevronDown
                                      : FontAwesomeIcons.chevronRight,
                                  color: Colors.white38,
                                  size: 12,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Terminées (${completedTasks.length})',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Completed Tasks
                      if (expanded && completedTasks.isNotEmpty) {
                        final completedIndex = index - activeTasks.length - 1;
                        if (completedIndex >= 0 &&
                            completedIndex < completedTasks.length) {
                          final task = completedTasks[completedIndex];
                          return TaskListItem(
                            task: task,
                            onToggle: () => ref
                                .read(taskProvider.notifier)
                                .toggleTask(task.id),
                            onDelete: () => ref
                                .read(taskProvider.notifier)
                                .deleteTask(task.id),
                          );
                        }
                      }

                      // Bottom spacing
                      return const SizedBox(height: 100);
                    },
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
