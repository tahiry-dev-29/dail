import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_input_provider.dart';
import 'task_input_actions.dart';
import '../../../../core/theme/adaptive_colors.dart';

class TaskInputWidget extends ConsumerWidget {
  final Function({
    required String name,
    required String description,
    required String time,
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
    // We can use glass surface or a specific input surface
    final surface = colors.isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.6); // Lighter for light mode input
    final borderColor = colors.border;

    return TapRegion(
      onTapOutside: (_) {
        if (onCancel != null) onCancel!();
      },
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
            TaskInputActions(state: state),
          ],
        ),
      ),
    );
  }

  void _handleSave(TaskInputState state) {
    final name = state.nameController.text.trim();
    if (name.isEmpty) {
      if (onCancel != null) onCancel!();
      return;
    }

    onSave(
      name: name,
      description: state.descController.text.trim(),
      time: state.time.peek(),
      deadline: state.deadline.peek(),
      isFavorite: state.isFavorite.peek(),
    );
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
    final textPrimary = colors.textPrimary;
    final hintColor = colors.textSecondary;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: state.nameController,
            focusNode: state.focusNode,
            style: TextStyle(color: textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => onSave(),
          ),
        ),
        GestureDetector(
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
    final textSecondary = colors.textSecondary;
    final hintColor = colors.textSecondary.withValues(alpha: 0.7);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: isExpanded
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: state.descController,
                  style: TextStyle(color: textSecondary, fontSize: 13),
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Ajouter une description...',
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
