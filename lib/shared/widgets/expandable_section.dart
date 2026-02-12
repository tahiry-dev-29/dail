import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Expandable section with animated chevron + size transition.
/// Uses a surgical StatefulWidget for [AnimationController] lifecycle.
class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isInitialExpanded;
  final Widget? trailing;
  final IconData? icon;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.isInitialExpanded = true,
    this.trailing,
    this.icon,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Signal<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = signal(widget.isInitialExpanded);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isInitialExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isExpanded.dispose();
    super.dispose();
  }

  void _toggle() {
    _isExpanded.value = !_isExpanded.value;
    if (_isExpanded.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Watch signal to rebuild on expand/collapse
    _isExpanded.watch(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                RotationTransition(
                  turns: _controller.drive(Tween(begin: 0.0, end: 0.25)),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textSecondary.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
                if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(widget.icon, color: colors.accent, size: 18),
                ],
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: .bold,
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _controller,
          axisAlignment: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
