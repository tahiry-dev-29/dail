import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/task_tag_picker.dart';
import 'package:daily_os/features/planner/presentation/components/task_edit/widgets/task_workspace_picker.dart';
import 'package:daily_os/features/planner/presentation/state/task_input_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Surgical StatefulWidget for [TaskInputViewModel] lifecycle (dispose).
class TaskInputWidget extends StatefulWidget {
  final Function({
    required String name,
    required String description,
    String? time,
    DateTime? deadline,
    required bool isFavorite,
    List<String> tagIds,
    String? workspaceId,
  })
  onSave;
  final VoidCallback? onCancel;
  final String hintText;
  final Map<String, dynamic> initialValues;

  const TaskInputWidget({
    super.key,
    required this.onSave,
    this.onCancel,
    this.hintText = 'Nouvelle Tâche',
    this.initialValues = const {},
  });

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  late final TaskInputViewModel _state;

  @override
  void initState() {
    super.initState();
    _state = TaskInputViewModel(widget.initialValues);
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _handleSave() {
    final name = _state.nameController.text.trim();
    if (name.isEmpty) {
      widget.onCancel?.call();
      return;
    }

    widget.onSave(
      name: name,
      description: _state.descController.text.trim(),
      time: _state.time.peek(),
      deadline: _state.deadline.peek(),
      isFavorite: _state.isFavorite.peek(),
      tagIds: _state.tagIds.peek(),
      workspaceId: _state.workspaceId.peek(),
    );
    _state.reset();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Glass surface styling
    final surface = colors.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = colors.border;

    return TapRegion(
      onTapOutside: (_) => widget.onCancel?.call(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            _TaskNameRow(
              state: _state,
              hintText: widget.hintText,
              onSave: _handleSave,
              colors: colors,
            ),
            _TaskDescriptionField(state: _state, colors: colors),
            const SizedBox(height: 12),
            _TaskInputActions(state: _state, colors: colors),
          ],
        ),
      ),
    );
  }
}

class _TaskNameRow extends StatelessWidget {
  final TaskInputViewModel state;
  final String hintText;
  final VoidCallback onSave;
  final AdaptiveColors colors;

  const _TaskNameRow({
    required this.state,
    required this.hintText,
    required this.onSave,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: state.nameController,
            focusNode: state.focusNode,
            style: TextStyle(color: colors.textPrimary, fontSize: 15),
            maxLength: 100,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: colors.textSecondary),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterText: '',
              suffix: ValueListenableBuilder(
                valueListenable: state.nameController,
                builder: (context, value, child) {
                  return Text(
                    '${value.text.length}/100',
                    style: TextStyle(
                      color: colors.textSecondary.withValues(alpha: 0.3),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            onSubmitted: (_) => onSave(),
          ),
        ),
        const SizedBox(width: 16),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onSave,
            child: Text(
              'Save',
              style: TextStyle(
                color: colors.accent,
                fontWeight: .w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskDescriptionField extends StatelessWidget {
  final TaskInputViewModel state;
  final AdaptiveColors colors;
  const _TaskDescriptionField({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isExpanded = state.isDescriptionExpanded.watch(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: isExpanded
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: state.descController,
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Ajouter une description...',
                    hintStyle: TextStyle(
                      color: colors.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    suffix: ValueListenableBuilder(
                      valueListenable: state.descController,
                      builder: (context, value, child) {
                        return Text(
                          '${value.text.length}/1000',
                          style: TextStyle(
                            color: colors.textSecondary.withValues(alpha: 0.3),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  maxLength: 1000,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _TaskInputActions extends StatelessWidget {
  final TaskInputViewModel state;
  final AdaptiveColors colors;

  const _TaskInputActions({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isFavorite = state.isFavorite.watch(context);
    final isDescExpanded = state.isDescriptionExpanded.watch(context);
    final time = state.time.watch(context);
    final deadline = state.deadline.watch(context);

    final hasTime = time != null && time.isNotEmpty;
    final hasDeadline = deadline != null;

    return Row(
      children: [
        ActionIcon(
          icon: AppIcons.description(context),
          onTap: () => state.isDescriptionExpanded.value = !isDescExpanded,
          color: isDescExpanded
              ? colors.accent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
        const SizedBox(width: 4),
        ActionIcon(
          icon: AppIcons.clock(context),
          onTap: () async {
            final tod = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (tod != null && context.mounted) {
              state.time.value = tod.format(context);
            }
          },
          color: hasTime
              ? colors.accent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
        const SizedBox(width: 4),
        ActionIcon(
          icon: AppIcons.priority(context),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null && context.mounted) {
              final tod = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (tod != null) {
                state.deadline.value = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  tod.hour,
                  tod.minute,
                );
              } else {
                state.deadline.value = date;
              }
            }
          },
          color: hasDeadline
              ? Colors.orangeAccent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
        const SizedBox(width: 4),
        _WorkspaceAction(state: state, colors: colors),
        const SizedBox(width: 4),
        _TagAction(state: state, colors: colors),
        const Spacer(),
        ActionIcon(
          icon: AppIcons.favorite(context, isFavorite),
          onTap: () => state.isFavorite.value = !isFavorite,
          color: isFavorite
              ? Colors.redAccent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
      ],
    );
  }
}

class _WorkspaceAction extends StatelessWidget {
  final TaskInputViewModel state;
  final AdaptiveColors colors;

  const _WorkspaceAction({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    final workspaceId = state.workspaceId.watch(context);
    final hasWorkspace = workspaceId != null;

    return ActionIcon(
      icon: Icons.workspaces_outlined,
      onTap: () {
        _showWorkspacePicker(context);
      },
      color: hasWorkspace
          ? colors.accent
          : colors.textSecondary.withValues(alpha: 0.5),
      size: 16,
    );
  }

  void _showWorkspacePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text('Workspace', style: context.h2),
            const SizedBox(height: 16),
            TaskWorkspacePicker(selectedWorkspaceId: state.workspaceId),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TagAction extends StatelessWidget {
  final TaskInputViewModel state;
  final AdaptiveColors colors;

  const _TagAction({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    final tagIds = state.tagIds.watch(context);
    final hasTags = tagIds.isNotEmpty;

    return ActionIcon(
      icon: Icons.label_outline,
      onTap: () {
        _showTagPicker(context);
      },
      color: hasTags
          ? colors.accent
          : colors.textSecondary.withValues(alpha: 0.5),
      size: 16,
    );
  }

  void _showTagPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text('Tags', style: context.h2),
            const SizedBox(height: 16),
            TaskTagPicker(selectedTagIds: state.tagIds),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
