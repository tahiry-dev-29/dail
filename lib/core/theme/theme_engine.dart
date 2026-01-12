import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized Theme Engine for DailyOS
class AppThemeEngine {
  // ===========================================================================
  // PALETTES
  // ===========================================================================

  static const Color _lightScaffold = Color(0xFFF8FAFC); // Slate-50
  static const Color _darkScaffold = Colors.black;

  // Modern Glass Colors
  // Light Mode: "Icy/Ceramic" look (White with variable opacity)
  static Color get lightGlass => Colors.white.withValues(alpha: 0.65);
  static Color get lightGlassBorder => Colors.white.withValues(alpha: 0.6);

  // Dark Mode: "Deep Space" look (White/Black tint with low opacity)
  static Color get darkGlass => const Color(0xFF0F172A).withValues(alpha: 0.6);
  static Color get darkGlassBorder => Colors.white.withValues(alpha: 0.1);

  // Text Colors - Modern High Contrast
  static const Color lightTextPrimary = Color(
    0xFF0F172A,
  ); // Slate-900 (Sharper black)
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate-500
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;

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
