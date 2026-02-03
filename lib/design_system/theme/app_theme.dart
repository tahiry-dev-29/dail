import 'package:daily_os/design_system/atoms/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Theme Engine for DailyOS
class AppTheme {
  // ===========================================================================
  // PALETTES
  // ===========================================================================

  static const Color _lightScaffold = Color(0xFFF8FAFC); // Slate-50
  static const Color _darkScaffold = Colors.black;

  // Modern Glass Colors
  // Light Mode: "Icy/Ceramic" look (White with variable opacity)
  static Color get lightGlass => Colors.white.withValues(alpha: 0.7);
  static Color get lightGlassBorder => Colors.white.withValues(alpha: 0.5);

  // Dark Mode: "Deep Space" look (White/Black tint with low opacity)
  static Color get darkGlass => const Color(0xFF0F172A).withValues(alpha: 0.6);
  static Color get darkGlassBorder => Colors.white.withValues(alpha: 0.12);

  // Text Colors - Modern High Contrast
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate-500
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate-50
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate-300

  // ===========================================================================
  // THEME DATA GENERATORS
  // ===========================================================================

  static ThemeData lightTheme(Color accent, String fontFamily) {
    final textTheme = _getTextTheme(fontFamily, ThemeData.light().textTheme);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightScaffold,
      primaryColor: accent,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: AppColors.aiColor,
        surface: lightGlass,
        onSurface: lightTextPrimary,
        outline: lightGlassBorder,
        error: const Color(0xFFEF4444), // red-500
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: lightGlass,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: lightGlassBorder),
        ),
      ),
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
        color: Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  static ThemeData darkTheme(Color accent, String fontFamily) {
    final textTheme = _getTextTheme(fontFamily, ThemeData.dark().textTheme);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkScaffold,
      primaryColor: accent,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: AppColors.aiColor,
        surface: darkGlass,
        onSurface: darkTextPrimary,
        outline: darkGlassBorder,
        error: const Color(0xFFF87171), // red-400
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: darkGlass,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: darkGlassBorder),
        ),
      ),
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
        color: Colors.white.withValues(alpha: 0.1),
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

  // Text colors
  Color get textPrimary =>
      isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondary =>
      isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get textMuted => isDark ? Colors.white38 : Colors.black38;

  Color get surface => isDark
      ? Colors.white.withValues(alpha: 0.07)
      : Colors.white.withValues(alpha: 0.65);

  Color get surfaceElevated => isDark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.white.withValues(alpha: 0.85);

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
}

extension AdaptiveColorsExtension on BuildContext {
  AdaptiveColors get colors => AdaptiveColors(this);
}
