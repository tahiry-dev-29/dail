import 'package:flutter/material.dart';
import 'theme_engine.dart';

class AdaptiveColors {
  final BuildContext context;
  AdaptiveColors(this.context);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // Text colors
  Color get textPrimary =>
      isDark ? AppThemeEngine.darkTextPrimary : AppThemeEngine.lightTextPrimary;
  Color get textSecondary => isDark
      ? AppThemeEngine.darkTextSecondary
      : AppThemeEngine.lightTextSecondary;
  Color get textMuted => isDark ? Colors.white38 : Colors.black38;

  // CSS Ref: background: rgba(255, 255, 255, 0.65);
  Color get surface => isDark
      ? Colors.white.withValues(alpha: 0.07)
      : Colors.white.withValues(alpha: 0.65);

  Color get surfaceElevated => isDark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.white.withValues(alpha: 0.85);

  // CSS Ref: border: 1px solid rgba(255, 255, 255, 0.4);
  Color get border => isDark
      ? Colors.white.withValues(alpha: 0.15)
      : Colors.white.withValues(alpha: 0.4);

  // CSS Ref: box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  // This is a subtle Navy Blue shadow for that "premium" tint
  Color get shadow => isDark
      ? Colors.black.withValues(alpha: 0.3)
      : const Color.fromARGB(255, 31, 38, 135).withValues(alpha: 0.07);

  // Icon colors
  Color get iconPrimary =>
      isDark ? AppThemeEngine.darkTextPrimary : AppThemeEngine.lightTextPrimary;
  Color get iconSecondary => isDark
      ? AppThemeEngine.darkTextSecondary
      : AppThemeEngine.lightTextSecondary;

  // Accent from theme
  Color get accent => Theme.of(context).colorScheme.primary;
}

extension AdaptiveColorsExtension on BuildContext {
  AdaptiveColors get colors => AdaptiveColors(this);
}
