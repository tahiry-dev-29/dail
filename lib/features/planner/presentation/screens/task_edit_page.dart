import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/subtask_list_manager.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_action_bar.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_date_time_pickers.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_details_section.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_edit_header.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/task_title_input.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskEditPage extends HookWidget {
  final TaskEntity task;

  const TaskEditPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize ViewModel via Hook and sl
    final viewModel = useMemoized(() => sl<TaskEditViewModel>(param1: task));

    // 2. Define Save Action
    void onSave() => viewModel.save();

    return GlassScaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: TaskEditHeader(viewModel: viewModel, onSave: onSave),
          ),

          // Body Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // List Category
                  Row(
                    children: [
                      const Text(
                        'General Task',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        AppIcons.caretDown(context),
                        color: Colors.blueAccent,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Inputs
                  TaskTitleInput(viewModel: viewModel, onSave: onSave),
                  const SizedBox(height: 24),

                  TaskDetailsSection(viewModel: viewModel, onSave: onSave),
                  TaskDateTimePickers(viewModel: viewModel, onSave: onSave),
                  SubtaskListManager(viewModel: viewModel, onSave: onSave),
                ],
              ),
            ),
          ),

          // Bottom Bar
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TaskActionBar(viewModel: viewModel, onSave: onSave),
            ),
          ),
        ],
      ),
    );
  }
}
