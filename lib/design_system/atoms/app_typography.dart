import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static TextStyle get h1 => const TextStyle(
    fontSize: 26,
    fontWeight: .w700,
    fontFamily: 'Outfit',
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => const TextStyle(
    fontSize: 22,
    fontWeight: .w600,
    fontFamily: 'Outfit',
    letterSpacing: -0.3,
  );

  static TextStyle get bodyLarge =>
      const TextStyle(fontSize: 16, fontWeight: .w500, fontFamily: 'Outfit');

  static TextStyle get bodyMedium =>
      const TextStyle(fontSize: 14, fontWeight: .w400, fontFamily: 'Outfit');

  static TextStyle get bodySmall =>
      const TextStyle(fontSize: 12, fontWeight: .w400, fontFamily: 'Outfit');

  static TextStyle get caption => const TextStyle(
    fontSize: 11,
    fontWeight: .w700,
    letterSpacing: 1.1,
    fontFamily: 'Outfit',
  );
}

extension AppTypographyExtension on BuildContext {
  TextStyle get h1 => AppTypography.h1.copyWith(color: colors.textPrimary);
  TextStyle get h2 => AppTypography.h2.copyWith(color: colors.textPrimary);
  TextStyle get bodyLarge =>
      AppTypography.bodyLarge.copyWith(color: colors.textPrimary);
  TextStyle get bodyMedium =>
      AppTypography.bodyMedium.copyWith(color: colors.textPrimary);
  TextStyle get bodySmall =>
      AppTypography.bodySmall.copyWith(color: colors.textSecondary);
  TextStyle get caption =>
      AppTypography.caption.copyWith(color: colors.textSecondary);
}
