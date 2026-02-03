import 'dart:ui';

import 'package:daily_os/features/calendar/logic/calendar_provider.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/task_input_widget.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class QuickAddTaskOverlay extends StatelessWidget {
  const QuickAddTaskOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isVisible = isAddTaskVisible.value;
      final parentTask = parentTaskSignal.value;

      if (!isVisible) return const SizedBox.shrink();

      final selectedDate = calendarState.selectedDate.value;

      void onSave({
        required String name,
        required String description,
        String? time,
        DateTime? deadline,
        required bool isFavorite,
      }) {
        if (parentTask != null) {
          plannerController.addSubtask(parentTask.id, name);
        } else {
          plannerController.addTask(
            name: name,
            description: description,
            time: time ?? '00:00',
            date: selectedDate,
            deadline: deadline,
            isFavorite: isFavorite,
          );
        }

        clearDraft();
        isAddTaskVisible.value = false;
        parentTaskSignal.value = null;

        ToastService.success(
          context,
          parentTask != null ? '✨ Sous-tâche ajoutée' : '✨ Tâche ajoutée',
        );
      }

      return Stack(
        children: [
          // Blurred Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                isAddTaskVisible.value = false;
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
            alignment: .bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
              ),
              child: TaskInputWidget(
                onSave: onSave,
                onCancel: () {
                  isAddTaskVisible.value = false;
                  parentTaskSignal.value = null;
                },
                hintText: parentTask != null
                    ? 'Sous-tâche pour "${parentTask.name}"...'
                    : 'Que faut-il faire ?',
              ),
            ),
          ),
        ],
      );
    });
  }
}
