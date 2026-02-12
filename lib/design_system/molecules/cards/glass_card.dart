import 'dart:ui' as ui;

import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final Color? color;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0, // CSS Ref: rounded-3xl (1.5rem = 24px)
    this.padding,
    this.margin,
    this.blur = 24.0, // CSS Ref: backdrop-filter: blur(24px)
    this.color,
    this.borderColor,
    this.useCustomBackground = true,
  });

  final bool useCustomBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blurValue = colors.blur;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color:
                  color ??
                  (useCustomBackground ? colors.customSurface : colors.surface),
              gradient: useCustomBackground ? colors.cardGradient : null,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor ?? colors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
