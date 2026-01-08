import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../providers/home_state.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeNextTaskWidget extends StatelessWidget {
  final String currentTaskName;

  const HomeNextTaskWidget({super.key, required this.currentTaskName});

  @override
  Widget build(BuildContext context) {
    // Watch the time signal from homeState
    final timeStr = homeState.timeString.watch(context);

    return GlassContainer(
      borderRadius: 25,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "EN COURS MAINTENANT",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentTaskName,
            style: const TextStyle(
              color: Colors.white,
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
