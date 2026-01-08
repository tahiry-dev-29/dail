import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/task_provider.dart';

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
    // Keep focus for adding multiple subtasks? Google Tasks keeps it.
    // But if we want to collapse, we might need to listen to closing.
    // For now, keep focus to allow rapid entry.
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return GestureDetector(
        onTap: () {
          setState(() => _isExpanded = true);
          // Schedule focus request
          Future.microtask(() => _focusNode.requestFocus());
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
          child: Row(
            children: [
              const Icon(
                FontAwesomeIcons.plus,
                color: Colors.white38,
                size: 14,
              ),
              const SizedBox(width: 12),
              Text(
                'Ajouter une sous-tâche',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _subtaskController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Titre de la sous-tâche',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
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
      ),
    );
  }
}
