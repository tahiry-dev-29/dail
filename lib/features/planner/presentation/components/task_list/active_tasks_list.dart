import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/features/planner/presentation/state/task_input_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class ActiveTasksList extends StatelessWidget {
  final List<TaskEntity> activeTasks;

  const ActiveTasksList({super.key, required this.activeTasks});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final taskListVM = sl<TaskListViewModel>();

    return SliverReorderableList(
      itemCount: activeTasks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final newOrder = List<TaskEntity>.from(activeTasks);
        final item = newOrder.removeAt(oldIndex);
        newOrder.insert(newIndex, item);

        taskListVM.reorderTasks(newOrder);
      },
      itemBuilder: (context, index) {
        final task = activeTasks[index];

        final doneBg = Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(AppIcons.check(context), color: Colors.green, size: 20),
              const SizedBox(width: 12),
              Text(
                'Terminée',
                style: context.bodyMedium.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );

        final nestBg = Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sous-tâche',
                style: context.bodyMedium.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Icon(AppIcons.add(context), color: colors.accent, size: 20),
            ],
          ),
        );

        return ReorderableDragStartListener(
          key: Key(task.id),
          index: index,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 2.0,
                ),
                child: Dismissible(
                  key: Key('dismiss_${task.id}'),
                  direction: DismissDirection.horizontal,
                  dismissThresholds: const {
                    DismissDirection.startToEnd: 0.2, // Right
                    DismissDirection.endToStart: 0.2, // Left
                  },
                  background: doneBg, // Right Swipe -> Done
                  secondaryBackground: nestBg, // Left Swipe -> Nest
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Left Swipe -> Add Subtask
                      parentTaskSignal.value = task;
                      sl<HomeViewModel>().isAddTaskVisible.value = true;
                      ToastService.info(
                        context,
                        'Ajout d\'une sous-tâche pour "${task.name}"',
                      );
                      return false; // Don't dismiss, just open the input
                    } else if (direction == DismissDirection.startToEnd) {
                      // Right Swipe -> Done
                      taskListVM.toggleTask(task.id);
                      ToastService.success(
                        context,
                        '✨ "${task.name}" terminée !',
                      );
                      return true;
                    }
                    return false;
                  },
                  child: TaskTile(
                    task: task,
                    onToggle: () => taskListVM.toggleTask(task.id),
                    onDelete: () => taskListVM.deleteTask(task.id),
                    onFavorite: () => taskListVM.updateTask(
                      task.copyWith(isFavorite: !task.isFavorite),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
