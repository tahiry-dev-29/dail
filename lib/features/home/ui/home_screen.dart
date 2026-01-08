import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../planner/providers/task_provider.dart';
import 'widgets/ai_insight_card.dart';
import 'widgets/home_next_task_widget.dart';
import 'widgets/stats_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    // Determine current task (first undone task)
    final currentTask = tasks.where((t) => !t.isDone).firstOrNull;
    final currentTaskName =
        currentTask?.name ?? (tasks.isEmpty ? "Repos" : "Terminé !");

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AI Insight
          const AiInsightCard(),
          const SizedBox(height: 20),

          // Next Task / Current Action (Extracted Widget)
          HomeNextTaskWidget(currentTaskName: currentTaskName),
          const SizedBox(height: 16),

          // Stats
          const StatsChart(),

          const SizedBox(height: 100), // Space for specific bottom padding
        ],
      ),
    );
  }
}
