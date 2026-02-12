import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_colors.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Theme Engine for DailyOS
class AppTheme {
  // ===========================================================================
  // PALETTES
  // ===========================================================================

  static const Color _lightScaffold = Color(0xFFF8FAFC); // Slate-50
  static const Color _darkScaffold = Color(
    0xFF030712,
  ); // Grey-950 (Premium Dark)

  // Modern Glass Colors
  // Light Mode: "Icy/Ceramic" look (White with variable opacity)
  static Color get lightGlass => Colors.white.withValues(alpha: 0.65);
  static Color get lightGlassBorder => Colors.white.withValues(alpha: 0.6);

  // Dark Mode: "Deep Space" look (White/Black tint with low opacity)
  static Color get darkGlass =>
      const Color(0xFF111827).withValues(alpha: 0.7); // Grey-900
  static Color get darkGlassBorder => Colors.white.withValues(alpha: 0.1);

  // Text Colors - Modern High Contrast
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate-500
  static const Color darkTextPrimary = Color(0xFFF9FAFB); // Grey-50
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // Grey-400

  // ===========================================================================
  // THEME DATA GENERATORS
  // ===========================================================================

  static ThemeData lightTheme(
    Color accent,
    String fontFamily,
    ThemeStyle style,
  ) {
    final textTheme = _getTextTheme(fontFamily, ThemeData.light().textTheme);
    final isGlass = style == ThemeStyle.glass;

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightScaffold,
      primaryColor: accent,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: AppColors.aiColor,
        surface: isGlass ? lightGlass : const Color(0xFFFFFFFF),
        onSurface: lightTextPrimary,
        outline: isGlass ? lightGlassBorder : const Color(0xFFE2E8F0),
      ),
      useMaterial3: true,
      textTheme: textTheme.apply(
        bodyColor: lightTextPrimary,
        displayColor: lightTextPrimary,
      ),
      iconTheme: const IconThemeData(color: lightTextPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isGlass
            ? Colors.black.withValues(alpha: 0.05)
            : const Color(0xFFE2E8F0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _getTextTheme(
              fontFamily,
              ThemeData.light().textTheme,
            ).labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: lightTextPrimary,
            );
          }
          return _getTextTheme(
            fontFamily,
            ThemeData.light().textTheme,
          ).labelSmall?.copyWith(
            fontWeight: FontWeight.normal,
            color: lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: lightTextPrimary);
          }
          return const IconThemeData(color: lightTextSecondary);
        }),
      ),
    );
  }

  static ThemeData darkTheme(
    Color accent,
    String fontFamily,
    ThemeStyle style,
  ) {
    final textTheme = _getTextTheme(fontFamily, ThemeData.dark().textTheme);
    final isGlass = style == ThemeStyle.glass;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkScaffold,
      primaryColor: accent,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: AppColors.aiColor,
        surface: isGlass ? darkGlass : const Color(0xFF111827),
        onSurface: darkTextPrimary,
        outline: isGlass
            ? darkGlassBorder
            : Colors.white.withValues(alpha: 0.1),
      ),
      useMaterial3: true,
      textTheme: textTheme.apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      iconTheme: const IconThemeData(color: darkTextPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isGlass
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _getTextTheme(fontFamily, ThemeData.dark().textTheme)
                .labelSmall
                ?.copyWith(fontWeight: FontWeight.w600, color: darkTextPrimary);
          }
          return _getTextTheme(
            fontFamily,
            ThemeData.dark().textTheme,
          ).labelSmall?.copyWith(
            fontWeight: FontWeight.normal,
            color: darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: darkTextPrimary);
          }
          return const IconThemeData(color: darkTextSecondary);
        }),
      ),
    );
  }

  static TextTheme _getTextTheme(String fontFamily, TextTheme base) {
    switch (fontFamily) {
      case 'Roboto':
        return GoogleFonts.robotoTextTheme(base);
      case 'Inter':
        return GoogleFonts.interTextTheme(base);
      case 'System':
        return base;
      case 'Outfit':
      default:
        return GoogleFonts.outfitTextTheme(base);
    }
  }
}

/// Helper for adaptive colors based on context
class AdaptiveColors {
  final BuildContext context;
  AdaptiveColors(this.context);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  bool get isGlass => sl<ThemeViewModel>().themeStyle.value == ThemeStyle.glass;

  // Text colors
  Color get textPrimary =>
      isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondary =>
      isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get textMuted => isDark ? Colors.white38 : Colors.black38;

  Color get surface => isDark
      ? (isGlass
            ? Colors.white.withValues(alpha: 0.07)
            : const Color(0xFF111827))
      : (isGlass ? Colors.white.withValues(alpha: 0.65) : Colors.white);

  Color get surfaceElevated => isDark
      ? (isGlass
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0xFF1F2937))
      : (isGlass
            ? Colors.white.withValues(alpha: 0.85)
            : const Color(0xFFF1F5F9));

  double get blur => isGlass ? 24.0 : 0.0;

  Color get background {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// The surface color applied to cards and containers.
  /// If a solid background is selected, it returns that color.
  Color get customSurface {
    final themeVM = sl<ThemeViewModel>();
    if (themeVM.backgroundType.value == BackgroundType.solid) {
      return themeVM.customSolidColor.value;
    }
    return surface;
  }

  /// The gradient applied to cards and containers.
  LinearGradient get cardGradient {
    final themeVM = sl<ThemeViewModel>();
    final type = themeVM.backgroundType.value;

    if (type == BackgroundType.gradient) {
      return LinearGradient(
        colors: themeVM.customGradient.value,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (type == BackgroundType.pro) {
      return _getProGradient(themeVM.proThemeId.value);
    }

    // Default: Return a transparent-ish gradient of the surface color
    final baseColor = customSurface;
    return LinearGradient(colors: [baseColor, baseColor]);
  }

  LinearGradient _getProGradient(String id) {
    return switch (id) {
      'midnight' => const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'arctic' => const LinearGradient(
        colors: [Color(0xFFF0F4F8), Color(0xFFD9E2EC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'sunset' => const LinearGradient(
        colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'neon' => const LinearGradient(
        colors: [Color(0xFF111827), Color(0xFF4C1D95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      _ => LinearGradient(
        colors: isDark
            ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
            : [const Color(0xFFF0F4F8), const Color(0xFFE2E8F0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };
  }

  Color get border => isDark
      ? Colors.white.withValues(alpha: 0.15)
      : Colors.white.withValues(alpha: 0.4);

  Color get shadow => isDark
      ? Colors.black.withValues(alpha: 0.3)
      : const Color.fromARGB(255, 31, 38, 135).withValues(alpha: 0.07);

  // Icon colors
  Color get iconPrimary =>
      isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get iconSecondary =>
      isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

  // Accent from theme
  Color get accent => Theme.of(context).colorScheme.primary;

  // AI color
  Color get ai => AppColors.aiColor;

  // Text on Accent (Usually white or black depending on accent brightness)
  Color get textOnAccent => Colors.white;

  Color get error => Colors.redAccent;
}

extension AdaptiveColorsExtension on BuildContext {
  AdaptiveColors get colors => AdaptiveColors(this);
}
