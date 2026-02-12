import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PrimaryCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isVisible;

  const PrimaryCircleButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.colors.ai, context.colors.accent],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.colors.ai.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 20)),
        ),
      ),
    );
  }
}
