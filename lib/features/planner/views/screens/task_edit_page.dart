import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_edit_view_model.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/subtask_list_manager.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/task_action_bar.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/task_date_time_pickers.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/task_details_section.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/task_edit_header.dart';
import 'package:daily_os/features/planner/views/widgets/task_edit/task_title_input.dart';
import 'package:daily_os/shared/widgets/audio_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskEditPage extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onBack;

  const TaskEditPage({super.key, required this.task, this.onBack});

  @override
  Widget build(BuildContext context) {
    final viewModel = sl<TaskEditViewModel>(param1: task);

    void onSave() => viewModel.save();

    return GlassScaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: TaskEditHeader(
              viewModel: viewModel,
              onSave: onSave,
              onBack: onBack,
            ),
          ),

          // Body Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 12),
                  // List Category — Workspace Dropdown
                  _WorkspaceDropdown(viewModel: viewModel),
                  const SizedBox(height: 16),

                  // Inputs
                  TaskTitleInput(viewModel: viewModel, onSave: onSave),
                  const SizedBox(height: 24),

                  TaskDetailsSection(viewModel: viewModel, onSave: onSave),
                  TaskDateTimePickers(viewModel: viewModel, onSave: onSave),
                  const SizedBox(height: 16),
                  AudioRecorderWidget(
                    audioPath: viewModel.audioPath.watch(context),
                    audioDurationMs: viewModel.audioDurationMs.watch(context),
                    onSaved: (path, durationMs) {
                      viewModel.audioPath.value = path;
                      viewModel.audioDurationMs.value = durationMs;
                      onSave();
                    },
                    onDelete: () {
                      viewModel.audioPath.value = null;
                      viewModel.audioDurationMs.value = null;
                      onSave();
                    },
                  ),
                  const SizedBox(height: 16),
                  SubtaskListManager(viewModel: viewModel, onSave: onSave),

                  // Save Button — inline at end of form
                  TaskActionBar(
                    viewModel: viewModel,
                    onSave: onSave,
                    onBack: onBack,
                  ),
                  // Clear bottom navbar
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact workspace selector for the task edit header.
class _WorkspaceDropdown extends StatelessWidget {
  final TaskEditViewModel viewModel;

  const _WorkspaceDropdown({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final workspacesState = workspaceVM.workspaces.watch(context);
    final activeId = viewModel.workspaceId.watch(context);

    return workspacesState.map(
      data: (workspaces) {
        final selected = workspaces.where((w) => w.id == activeId).firstOrNull;
        final label = selected?.name ?? 'General Task';

        return PopupMenuButton<String?>(
          onSelected: (id) => viewModel.workspaceId.value = id,
          itemBuilder: (_) => [
            PopupMenuItem<String?>(value: null, child: Text('General Task')),
            ...workspaces.map(
              (ws) => PopupMenuItem<String?>(
                value: ws.id,
                child: Row(
                  children: [
                    Text(ws.iconEmoji),
                    const SizedBox(width: 8),
                    Text(ws.name),
                  ],
                ),
              ),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.accent,
                size: 16,
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, s) => const Text('Error'),
    );
  }
}
