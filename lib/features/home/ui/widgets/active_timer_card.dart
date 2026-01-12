import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../planner/providers/task_provider.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../core/theme/adaptive_colors.dart';

class ActiveTimerCard extends ConsumerWidget {
  const ActiveTimerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final currentTask = tasks.where((t) => !t.isDone).firstOrNull;
    final taskName =
        currentTask?.name ?? (tasks.isEmpty ? 'Repos' : 'Terminé !');

    final colors = context.colors;
    final isDark = colors.isDark;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      borderRadius: 24,
      child: Column(
        children: [
          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'EN COURS MAINTENANT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Task Title
          Text(
            taskName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Time Display
          // Using Gradient Text for Modern Look
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, Colors.lightBlueAccent]
                  : [
                      const Color(0xFF1E293B),
                      const Color(0xFF3B82F6),
                    ], // DarkSlate to Blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              currentTask?.time ?? '09:00',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: Colors.white, // Masked by shader
                letterSpacing: -2,
                fontFamily: 'Outfit', // Ensure font is applied if loaded
              ),
            ),
          ),
        ],
      ),
    );
  }
}
