import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskInputWidget extends ConsumerWidget {
  final Function({
    required String name,
    required String description,
    String? time,
    DateTime? deadline,
    required bool isFavorite,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskInputProvider(initialValues));
    final colors = context.colors;

    // Glass surface styling
    final surface = colors.isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.6);
    final borderColor = colors.border;

    return TapRegion(
      onTapOutside: (_) => onCancel?.call(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TaskNameRow(
              state: state,
              hintText: hintText,
              onSave: () => _handleSave(state),
              colors: colors,
            ),
            _TaskDescriptionField(state: state, colors: colors),
            const SizedBox(height: 12),
            _TaskInputActions(state: state, colors: colors),
          ],
        ),
      ),
    );
  }

  void _handleSave(TaskInputState state) {
    final name = state.nameController.text.trim();
    if (name.isEmpty) {
      onCancel?.call();
      return;
    }

    onSave(
      name: name,
      description: state.descController.text.trim(),
      time: state.time.peek(),
      deadline: state.deadline.peek(),
      isFavorite: state.isFavorite.peek(),
    );
    state.reset();
  }
}

class _TaskNameRow extends StatelessWidget {
  final TaskInputState state;
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
                fontWeight: FontWeight.w600,
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
  final TaskInputState state;
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
  final TaskInputState state;
  final AdaptiveColors colors;

  const _TaskInputActions({required this.state, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isFavorite = state.isFavorite.watch(context);
    final isDescExpanded = state.isDescriptionExpanded.watch(context);
    final time = state.time.watch(context);
    final deadline = state.deadline.watch(context);

    // Active checks
    final hasTime = time != null && time.isNotEmpty;
    final hasDeadline = deadline != null;

    return Row(
      children: [
        // Toggle Description
        ActionIcon(
          icon: AppIcons.description(context),
          onTap: () => state.isDescriptionExpanded.value = !isDescExpanded,
          color: isDescExpanded
              ? colors.accent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
        const SizedBox(width: 4),
        // Time Picker
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

        // Deadline Picker
        ActionIcon(
          icon: AppIcons.priority(context),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              if (context.mounted) {
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
                  // If time picker is cancelled, just set the date
                  state.deadline.value = date;
                }
              } else {
                // If context is not mounted, just set the date
                state.deadline.value = date;
              }
            }
          },
          color: hasDeadline
              ? Colors.orangeAccent
              : colors.textSecondary.withValues(alpha: 0.5),
          size: 16,
        ),
        const Spacer(),

        // Toggle Favorite
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
