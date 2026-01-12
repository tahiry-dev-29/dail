import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/task_provider.dart';
import '../../providers/task_selectors.dart';
import '../../data/task_model.dart';
import 'task_list_item.dart';
import '../../../../shared/utils/toast_service.dart';
import 'package:daily_os/core/theme/adaptive_colors.dart';

class ActiveTasksList extends ConsumerWidget {
  const ActiveTasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasks = ref.watch(activeTasksProvider);

    return SliverReorderableList(
      itemCount: activeTasks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final newOrder = List<Task>.from(activeTasks);
        final item = newOrder.removeAt(oldIndex);
        newOrder.insert(newIndex, item);

        ref.read(taskProvider.notifier).updateTaskOrder(newOrder);
      },
      itemBuilder: (context, index) {
        final task = activeTasks[index];

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
              direction: DismissDirection.horizontal,
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.2,
                DismissDirection.endToStart: 0.2,
              },
              background: nestBg,
              secondaryBackground: doneBg,
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
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
                        targetParentId: activeTasks[index - 1].id,
                      );
                  ToastService.success(
                    context,
                    '📂 "${task.name}" imbriquée sous "${activeTasks[index - 1].name}"',
                  );
                  return true;
                } else if (direction == DismissDirection.endToStart) {
                  ref.read(taskProvider.notifier).toggleTask(task.id);
                  ToastService.success(context, '✨ "${task.name}" terminée !');
                  return true;
                }
                return false;
              },
              child: TaskListItem(
                task: task,
                onToggle: () =>
                    ref.read(taskProvider.notifier).toggleTask(task.id),
                onDelete: () =>
                    ref.read(taskProvider.notifier).deleteTask(task.id),
              ),
            ),
          ),
        );
      },
    );
  }
}
