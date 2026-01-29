import 'package:flutter/material.dart';
import 'package:daily_os/core/theme/adaptive_colors.dart';
import 'package:daily_os/core/utils/app_icons.dart';

class CheckCircle extends StatelessWidget {
  final bool isDone;
  final bool isIgnored;
  final Color accent;
  final Color mutedIcon;
  final VoidCallback onTap;

  const CheckCircle({
    required this.isDone,
    required this.isIgnored,
    required this.accent,
    required this.mutedIcon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final warningColor = colors.isDark
        ? Colors.redAccent.withValues(alpha: 0.8)
        : Colors.red;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDone
                ? accent
                : (isIgnored
                      ? warningColor.withValues(alpha: 0.6)
                      : mutedIcon.withValues(alpha: 0.3)),
            width: 2,
          ),
          color: isDone ? accent : Colors.transparent,
        ),
        child: isDone
            ? Center(
                child: Icon(
                  AppIcons.check(context),
                  size: 10,
                  color: Colors.white,
                ),
              )
            : (isIgnored
                  ? Center(
                      child: Icon(
                        AppIcons.xmark(context),
                        size: 10,
                        color: warningColor,
                      ),
                    )
                  : null),
      ),
    );
  }
}
