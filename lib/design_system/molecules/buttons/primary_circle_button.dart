import 'package:daily_os/design_system/atoms/app_colors.dart';
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
            gradient: const LinearGradient(
              colors: [AppColors.purple500, AppColors.blue500],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.purple500.withValues(alpha: 0.4),
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
