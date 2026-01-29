import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DeadlineBadge extends StatelessWidget {
  final DateTime deadline;

  const DeadlineBadge({required this.deadline, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orangeColor = isDark ? Colors.orangeAccent : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: orangeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.clock, size: 9, color: orangeColor),
          const SizedBox(width: 4),
          Text(
            DateFormat('HH:mm').format(deadline),
            style: TextStyle(
              color: orangeColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
