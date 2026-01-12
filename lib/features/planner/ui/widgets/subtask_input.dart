import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/task_provider.dart';

import '../../../../core/theme/adaptive_colors.dart';

class SubtaskInput extends ConsumerStatefulWidget {
  final String taskId;

  const SubtaskInput({super.key, required this.taskId});

  @override
  ConsumerState<SubtaskInput> createState() => _SubtaskInputState();
}

class _SubtaskInputState extends ConsumerState<SubtaskInput> {
  final _subtaskController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _subtaskController.text.isEmpty) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _subtaskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;

    ref.read(taskProvider.notifier).addSubtask(widget.taskId, text);
    _subtaskController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textPrimary = colors.textPrimary;
    final textSecondary = colors.textSecondary;
    final accent = colors.accent;

    if (!_isExpanded) {
      return GestureDetector(
        onTap: () {
          setState(() => _isExpanded = true);
          Future.microtask(() => _focusNode.requestFocus());
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.plus,
                color: textSecondary.withValues(alpha: 0.5),
                size: 14,
              ),
              const SizedBox(width: 12),
              Text(
                'Ajouter une sous-tâche',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _subtaskController,
              focusNode: _focusNode,
              style: TextStyle(color: textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Titre de la sous-tâche',
                hintStyle: TextStyle(
                  color: textSecondary.withValues(alpha: 0.5),
                ),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _addSubtask(),
            ),
          ),
          GestureDetector(
            onTap: _addSubtask,
            child: Text(
              'Save',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
