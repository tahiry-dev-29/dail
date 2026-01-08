import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../data/task_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Opacity(
        opacity: task.isDone ? 0.5 : 1.0,
        child: GlassContainer(
          borderRadius: 22,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Check Circle
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isDone ? Colors.blueAccent : Colors.white24,
                      width: 2,
                    ),
                    color: task.isDone ? Colors.blueAccent : Colors.transparent,
                  ),
                  child: task.isDone
                      ? const Center(
                          child: Icon(
                            FontAwesomeIcons.check,
                            size: 10,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: GestureDetector(
                  onTap: onToggle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.time,
                        style: const TextStyle(
                          color: Colors.lightBlueAccent, // Blue-300
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        task.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              const Icon(
                FontAwesomeIcons.bars,
                color: Colors.white24,
                size: 16,
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white24,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
