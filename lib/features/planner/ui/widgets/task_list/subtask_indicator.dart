import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubtaskIndicator extends StatelessWidget {
  final int done;
  final int total;
  final Color color;

  const SubtaskIndicator({
    required this.done,
    required this.total,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          FontAwesomeIcons.listCheck,
          size: 10,
          color: color.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 3),
        Text(
          '$done/$total',
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
