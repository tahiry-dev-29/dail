import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Reusable section label header for Sidebar sections
class SidebarSectionLabel extends StatelessWidget {
  final String label;
  final bool? isExpanded;
  final VoidCallback? onToggle;

  const SidebarSectionLabel({
    super.key,
    required this.label,
    this.isExpanded,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
          child: Row(
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (onToggle != null && isExpanded != null) ...[
                const Spacer(),
                Icon(
                  isExpanded!
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 16,
                  color: context.colors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
