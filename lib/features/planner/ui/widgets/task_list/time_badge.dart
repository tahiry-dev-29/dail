import 'package:flutter/material.dart';

class TimeBadge extends StatelessWidget {
  final String time;
  final bool isOverdue;
  final Color accent;

  const TimeBadge({
    required this.time,
    required this.isOverdue,
    required this.accent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark
        ? Colors.redAccent.withValues(alpha: 0.8)
        : Colors.red;
    final color = isOverdue ? warningColor : accent;

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
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
