import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:flutter/material.dart';

class TaskSubtaskIndicator extends StatelessWidget {
  final int done;
  final int total;
  final Color color;

  const TaskSubtaskIndicator({
    super.key,
    required this.done,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        Icon(AppIcons.listCheck(context), size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          '$done/$total',
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.6),
            fontWeight: .w500,
          ),
        ),
      ],
    );
  }
}
