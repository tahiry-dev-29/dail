import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/widgets/glass_container.dart';

class StatsGrid extends StatelessWidget {
  final int doneCount;
  final int remainingCount;

  const StatsGrid({
    super.key,
    required this.doneCount,
    required this.remainingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: FontAwesomeIcons.circleCheck,
            iconColor: Colors.greenAccent,
            value: doneCount.toString(),
            label: 'Terminées',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: FontAwesomeIcons.clock,
            iconColor: Colors.orangeAccent,
            value: remainingCount.toString(),
            label: 'Restantes',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 100, // Fixed height for visual consistency
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
