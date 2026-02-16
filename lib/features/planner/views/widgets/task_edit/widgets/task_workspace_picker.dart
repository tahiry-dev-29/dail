import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskWorkspacePicker extends StatelessWidget {
  final Signal<String?> selectedWorkspaceId;

  const TaskWorkspacePicker({super.key, required this.selectedWorkspaceId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final workspaceVM = sl<WorkspaceViewModel>();
    final workspacesState = workspaceVM.workspaces.watch(context);
    final activeId = selectedWorkspaceId.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WORKSPACE', style: context.caption),
        const SizedBox(height: 8),
        workspacesState.map(
          data: (workspaces) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: activeId,
                  hint: Text('Select Workspace', style: context.bodySmall),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Global (No Workspace)'),
                    ),
                    ...workspaces.map(
                      (ws) => DropdownMenuItem<String?>(
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
                  onChanged: (id) => selectedWorkspaceId.value = id,
                ),
              ),
            );
          },
          error: (e, _) => Text('Error loading workspaces'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
