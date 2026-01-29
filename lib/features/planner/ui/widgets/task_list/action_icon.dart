import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }
}
