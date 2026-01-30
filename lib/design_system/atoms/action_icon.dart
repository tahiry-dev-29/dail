import 'package:flutter/material.dart';

/// Icône d'action réutilisable avec curseur click et padding uniforme.
///
/// Utilisé pour les actions rapides dans les listes (edit, delete, promote...).
class ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final EdgeInsets padding;

  const ActionIcon({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
    this.size = 14,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: padding,
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }
}
