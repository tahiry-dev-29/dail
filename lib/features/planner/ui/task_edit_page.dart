import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/glass_scaffold.dart';
import '../data/task_model.dart';
import '../providers/task_edit_controller.dart';
import 'widgets/task_edit_header.dart';
import 'widgets/task_title_input.dart';
import 'widgets/task_details_section.dart';
import 'widgets/task_date_time_pickers.dart';
import 'widgets/subtask_list_manager.dart';
import 'widgets/task_action_bar.dart';

// Pro 2026: Stateless + Riverpod/Signals
class TaskEditPage extends ConsumerWidget {
  final Task task;

  const TaskEditPage({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Initialize Controller (AutoDispose handles lifecycle)
    final controller = ref.watch(taskEditControllerProvider(task));

    // 2. Define Save Action
    void onSave() => controller.save(ref);

    return GlassScaffold(
      body: Column(
        children: [
          // Header
          TaskEditHeader(controller: controller, onSave: onSave),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // List Category (Static for now
                  const SizedBox(height: 16),

                  // Inputs
                  TaskTitleInput(controller: controller, onSave: onSave),
                  const SizedBox(height: 24),

                  TaskDetailsSection(controller: controller, onSave: onSave),
                  TaskDateTimePickers(controller: controller, onSave: onSave),
                  SubtaskListManager(controller: controller, onSave: onSave),
                ],
              ),
            ),
          ),

          // Bottom Bar
          TaskActionBar(controller: controller, onSave: onSave),
        ],
      ),
    );
  }
}
