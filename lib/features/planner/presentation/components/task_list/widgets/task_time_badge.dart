import 'package:flutter/material.dart';

class TaskTimeBadge extends StatelessWidget {
  final String time;
  final bool isOverdue;
  final Color accent;

  const TaskTimeBadge({
    super.key,
    required this.time,
    required this.isOverdue,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = isOverdue ? Colors.red : accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: .w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
