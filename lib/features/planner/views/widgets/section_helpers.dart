import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Reusable micro-widgets for dashboard sections.

/// Displays a small pill badge with a count number.
class CountBadge extends StatelessWidget {
  final int count;
  final bool isError;
  final bool isAccent;

  const CountBadge({
    super.key,
    required this.count,
    this.isError = false,
    this.isAccent = true,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final colors = context.colors;

    final color = isError
        ? colors.error
        : (isAccent ? colors.accent : colors.textSecondary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// A centered italic message for empty list sections.
class EmptySection extends StatelessWidget {
  final String message;

  const EmptySection({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// A section header row: icon + title + trailing widget.
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, color: colors.accent, size: 18),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
