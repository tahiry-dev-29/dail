import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExpandableSection extends HookWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isExpanded = useState(isInitialExpanded);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: isInitialExpanded ? 1.0 : 0.0,
    );

    useEffect(() {
      if (isExpanded.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isExpanded.value]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                RotationTransition(
                  turns: animationController.drive(
                    Tween(begin: 0.0, end: 0.25),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textSecondary.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: colors.accent, size: 18),
                ],
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: animationController,
          axisAlignment: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: child,
          ),
        ),
      ],
    );
  }
}
