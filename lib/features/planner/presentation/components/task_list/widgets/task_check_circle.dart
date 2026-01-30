import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TaskCheckCircle extends StatelessWidget {
  final bool isDone;
  final bool isIgnored;
  final VoidCallback onToggle;

  const TaskCheckCircle({
    super.key,
    required this.isDone,
    this.isIgnored = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.accent;
    final muted = colors.textSecondary.withValues(alpha: 0.3);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone
                  ? accent
                  : (isIgnored ? Colors.red.withValues(alpha: 0.6) : muted),
              width: 1.5,
            ),
            color: isDone ? accent : Colors.transparent,
            boxShadow: isDone
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isDone
              ? Center(
                  child: Icon(
                    AppIcons.check(context),
                    size: 11,
                    color: Colors.white,
                  ),
                )
              : (isIgnored
                    ? Center(
                        child: Icon(
                          AppIcons.xmark(context),
                          size: 10,
                          color: Colors.red,
                        ),
                      )
                    : null),
        ),
      ),
    );
  }
}
