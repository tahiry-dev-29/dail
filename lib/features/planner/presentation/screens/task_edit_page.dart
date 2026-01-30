import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/subtask_list_manager.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_action_bar.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_date_time_pickers.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_details_section.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_edit_header.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_title_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskEditPage extends ConsumerWidget {
  final TaskEntity task;

  const TaskEditPage({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Initialize Controller (AutoDispose handles lifecycle)
    final controller = ref.watch(taskEditControllerProvider(task));

    // 2. Define Save Action
    void onSave() => controller.save(ref);

    return GlassScaffold(
      body: CustomScrollView(
        slivers: [
          // Header (Sliver version if compatible, or SliverToBoxAdapter)
          SliverToBoxAdapter(
            child: TaskEditHeader(controller: controller, onSave: onSave),
          ),

          // Body Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 12),
                  // List Category
                  Row(
                    children: [
                      Text(
                        'General Task',
                        style: TextStyle(
                          color: Colors.blueAccent.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: .w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        AppIcons.caretDown(context),
                        color: Colors.blueAccent.withValues(alpha: 0.8),
                        size: 14,
                      ),
                    ],
                  ),
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

          // Bottom Bar (Fixed at bottom via another mechanism or simply last sliver)
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TaskActionBar(controller: controller, onSave: onSave),
            ),
          ),
        ],
      ),
    );
  }
}
