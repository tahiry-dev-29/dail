import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_list/task_tile.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/add_task_inline.dart';

class ActiveTasksList extends ConsumerWidget {
  final List<TaskEntity> activeTasks;

  const ActiveTasksList({super.key, required this.activeTasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isVisible = isAddTaskVisible.watch(context);
    final parentTask = parentTaskSignal.watch(context);

    return SliverReorderableList(
      itemCount: activeTasks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final newOrder = List<TaskEntity>.from(activeTasks);
        final item = newOrder.removeAt(oldIndex);
        newOrder.insert(newIndex, item);

        ref.read(taskListProvider.notifier).updateTaskOrder(newOrder);
      },
      itemBuilder: (context, index) {
        final task = activeTasks[index];

        final doneBg = Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          color: Colors.transparent,
          child: const Icon(
            FontAwesomeIcons.check,
            color: Colors.green,
            size: 20,
          ),
        );

        final nestBg = Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.transparent,
          child: Icon(FontAwesomeIcons.plus, color: colors.accent, size: 20),
        );

        return ReorderableDragStartListener(
          key: Key(task.id),
          index: index,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 4.0,
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
                      isAddTaskVisible.value = true;
                      ToastService.info(
                        context,
                        'Ajout d\'une sous-tâche pour "${task.name}"',
                      );
                      return false; // Don't dismiss, just open the input
                    } else if (direction == DismissDirection.startToEnd) {
                      // Right Swipe -> Done
                      ref.read(taskListProvider.notifier).toggleTask(task.id);
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
                    onToggle: () =>
                        ref.read(taskListProvider.notifier).toggleTask(task.id),
                    onDelete: () =>
                        ref.read(taskListProvider.notifier).deleteTask(task.id),
                    onFavorite: () => ref
                        .read(taskListProvider.notifier)
                        .toggleFavorite(task.id),
                  ),
                ),
              ),
              if (isVisible && parentTask?.id == task.id)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: AddTaskInline(),
                ),
            ],
          ),
        );
      },
    );
  }
}
