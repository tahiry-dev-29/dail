import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDeadlineBadge extends StatelessWidget {
  final DateTime deadline;

  const TaskDeadlineBadge({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(AppIcons.clock(context), size: 9, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            DateFormat('HH:mm').format(deadline),
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 10,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
