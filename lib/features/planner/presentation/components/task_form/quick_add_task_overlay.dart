import 'dart:ui';

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:daily_os/features/planner/presentation/state/task_input_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class QuickAddTaskOverlay extends StatelessWidget {
  const QuickAddTaskOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = sl<HomeViewModel>().isAddTaskVisible.watch(context);
    final parentTask = parentTaskSignal.watch(context);

    if (!isVisible) return const SizedBox.shrink();

    final taskListVM = sl<TaskListViewModel>();
    final calendarVM = sl<CalendarViewModel>();
    final selectedDate = calendarVM.selectedDate.value;

    void onSave({
      required String name,
      required String description,
      String? time,
      DateTime? deadline,
      required bool isFavorite,
      List<String> tagIds = const [],
      String? workspaceId,
    }) {
      if (parentTask != null) {
        // Add subtask (subtasks don't support tags/workspace directly in entity yet, but keep signature)
        final newSubtask = SubTaskEntity(
          id: Uuid().v4(),
          name: name,
          description: description,
          time: time ?? '00:00',
          deadline: deadline,
          isFavorite: isFavorite,
        );

        final updatedParent = parentTask.copyWith(
          subtasks: [...parentTask.subtasks, newSubtask],
        );

        taskListVM.updateTask(updatedParent);
      } else {
        // Add regular task
        taskListVM.addTask(
          name: name,
          description: description,
          time: time ?? '00:00',
          date: selectedDate,
          deadline: deadline,
          isFavorite: isFavorite,
          tagIds: tagIds,
          workspaceId: workspaceId,
          folderId: taskListVM.selectedFolderId.value,
          iconEmoji: '📝',
        );
      }

      clearDraft();
      sl<HomeViewModel>().isAddTaskVisible.value = false;
      parentTaskSignal.value = null;

      ToastService.success(
        context,
        parentTask != null ? '✨ Sous-tâche ajoutée' : '✨ Tâche ajoutée',
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Blurred Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                sl<HomeViewModel>().isAddTaskVisible.value = false;
                parentTaskSignal.value = null;
              },
              behavior: HitTestBehavior.opaque,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withValues(alpha: 0.2)),
              ),
            ),
          ),

          // Input Area
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
              ),
              child: TaskInputWidget(
                onSave: onSave,
                onCancel: () {
                  sl<HomeViewModel>().isAddTaskVisible.value = false;
                  parentTaskSignal.value = null;
                },
                hintText: parentTask != null
                    ? 'Sous-tâche pour "${parentTask.name}"...'
                    : 'Que faut-il faire ?',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
