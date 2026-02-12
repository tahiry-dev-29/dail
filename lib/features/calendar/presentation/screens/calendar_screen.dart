import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/presentation/components/grid/calendar_grid.dart';
import 'package:daily_os/features/calendar/presentation/components/grid/calendar_header.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

// ... (rest of imports)

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarVM = sl<CalendarViewModel>();
    final taskListVM = sl<TaskListViewModel>();

    final currentMonth = calendarVM.selectedDate.watch(context);
    final tasksState = taskListVM.filteredTasks.watch(context);

    final colors = context.colors;
    final headerColor = colors.textSecondary;

    return GlassScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Card
            GlassCard(
              borderRadius: 30,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CalendarHeader(currentMonth: currentMonth),
                  const SizedBox(height: 20),
                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ["L", "M", "M", "J", "V", "S", "D"]
                        .map(
                          (day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: AppTypography.bodySmall.copyWith(
                                  color: headerColor.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  const CalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Selection details
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
              child: Text(
                'PROGRAMME DU JOUR',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            tasksState.map(
              data: (tasks) => tasks.isEmpty
                  ? EmptyState(
                      icon: Icons.event_note_rounded,
                      title: 'Journée libre',
                      subtitle: 'Aucune tâche prévue pour cette date.',
                    )
                  : Column(
                      children: tasks
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TaskTile(
                                task: task,
                                onToggle: () => taskListVM.toggleTask(task.id),
                                onDelete: () => taskListVM.deleteTask(task.id),
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Erreur: $e')),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
