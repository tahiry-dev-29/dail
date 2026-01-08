import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/subtask_model.dart';
import '../../providers/task_provider.dart';

class SubtaskList extends ConsumerWidget {
  final String taskId;
  final List<SubTask> subtasks;

  const SubtaskList({super.key, required this.taskId, required this.subtasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (subtasks.isEmpty) return const SizedBox.shrink();

    return Column(
      children: subtasks
          .map(
            (st) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => ref
                        .read(taskProvider.notifier)
                        .toggleSubtask(taskId, st.id),
                    child: Icon(
                      st.isDone
                          ? FontAwesomeIcons.squareCheck
                          : FontAwesomeIcons.square,
                      color: st.isDone ? Colors.greenAccent : Colors.white38,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      st.name,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        decoration: st.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
