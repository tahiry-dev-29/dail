import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_input_provider.dart';
import 'task_input_actions.dart';

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

  // Initial values grouped for the provider family
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
    // Controller handled by Riverpod autoDispose
    final state = ref.watch(taskInputProvider(initialValues));

    return TapRegion(
      onTapOutside: (_) {
        if (onCancel != null) {
          onCancel!();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TaskNameRow(
              state: state,
              hintText: hintText,
              onSave: () => _handleSave(state),
            ),
            _TaskDescriptionField(state: state),
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

// Micro-component for Name Input
class _TaskNameRow extends StatelessWidget {
  final TaskInputState state;
  final String hintText;
  final VoidCallback onSave;

  const _TaskNameRow({
    required this.state,
    required this.hintText,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: state.nameController,
            focusNode: state.focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => onSave(),
          ),
        ),
        GestureDetector(
          onTap: onSave,
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Micro-component for Description
class _TaskDescriptionField extends StatelessWidget {
  final TaskInputState state;
  const _TaskDescriptionField({required this.state});

  @override
  Widget build(BuildContext context) {
    // Only this micro-widget rebuilds when isDescriptionExpanded changes
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
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Ajouter une description...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
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
