import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../providers/home_state.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeNextTaskWidget extends StatelessWidget {
  final String currentTaskName;

  const HomeNextTaskWidget({super.key, required this.currentTaskName});

  @override
  Widget build(BuildContext context) {
    final timeStr = homeState.timeString.watch(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textMuted = isDark
        ? Colors.white.withValues(alpha: 0.4)
        : Colors.black54;

    return GlassContainer(
      borderRadius: 25,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "EN COURS MAINTENANT",
            style: TextStyle(
              color: textMuted,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentTaskName,
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 40,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
