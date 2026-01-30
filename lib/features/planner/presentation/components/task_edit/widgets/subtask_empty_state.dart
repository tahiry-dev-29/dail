import 'package:flutter/material.dart';

class SubtaskEmptyState extends StatelessWidget {
  final VoidCallback onPressed;
  final Color accent;

  const SubtaskEmptyState({
    super.key,
    required this.onPressed,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add, size: 16, color: accent),
      label: Text(
        'Ajouter une sous-tâche',
        style: TextStyle(color: accent, fontSize: 13),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: .shrinkWrap,
      ),
    );
  }
}
