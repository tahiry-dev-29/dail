import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;
  final double iconSize;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            GlassCard(
              borderRadius: 50,
              padding: const EdgeInsets.all(12),
              color: colors.surface,
              borderColor: colors.border,
              child: Icon(icon, color: colors.textSecondary, size: iconSize),
            ),
            if (hasBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.colors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.isDark ? Colors.black : Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
