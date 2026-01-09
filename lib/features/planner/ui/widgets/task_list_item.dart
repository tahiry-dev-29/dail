import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../task_edit_page.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../data/task_model.dart';
import '../../providers/task_provider.dart';

class TaskListItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Opacity(
        opacity: task.isDone ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
            );
          },
          child: GlassContainer(
            borderRadius: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Row
                Row(
                  children: [
                    // Check Circle
                    GestureDetector(
                      onTap: onToggle,
                      behavior:
                          HitTestBehavior.opaque, // Ensure tap target is good
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: task.isDone
                                ? Colors.blueAccent
                                : Colors.white24,
                            width: 2,
                          ),
                          color: task.isDone
                              ? Colors.blueAccent
                              : Colors.transparent,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                task.time,
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (task.deadline != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    DateFormat(
                                      'dd/MM HH:mm',
                                    ).format(task.deadline!),
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            task.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Favorite
                    GestureDetector(
                      onTap: () => ref
                          .read(taskProvider.notifier)
                          .toggleFavorite(task.id),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        // Added padding for touch target
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          task.isFavorite
                              ? FontAwesomeIcons.solidStar
                              : FontAwesomeIcons.star,
                          color: task.isFavorite
                              ? Colors.amber
                              : Colors.white24,
                          size: 16,
                        ),
                      ),
                    ),

                    // Delete
                    GestureDetector(
                      onTap: onDelete,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.white24,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
