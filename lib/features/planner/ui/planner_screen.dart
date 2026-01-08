import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../planner/providers/task_provider.dart';
import 'widgets/task_list_item.dart';
import '../../../shared/widgets/glass_container.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Column(
      children: [
        // Sticky Headerish thing (Timeline title + Add Button)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Timeline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Logic to open Add Modal (mocked for now)
                  // We could use a Signal to open a modal, or just showDialog here.
                  // As per original plan: "Add Task Modal"
                  // Let's just add a dummy task for demo
                  ref
                      .read(taskProvider.notifier)
                      .addTask("Nouvelle Tâche", "12:00");
                },
                child: const GlassContainer(
                  borderRadius: 50,
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.blueAccent,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: tasks.length + 1, // Space at bottom
            itemBuilder: (context, index) {
              if (index == tasks.length) return const SizedBox(height: 100);
              final task = tasks[index];
              return TaskListItem(
                task: task,
                onToggle: () =>
                    ref.read(taskProvider.notifier).toggleTask(task.id),
                onDelete: () =>
                    ref.read(taskProvider.notifier).deleteTask(task.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
