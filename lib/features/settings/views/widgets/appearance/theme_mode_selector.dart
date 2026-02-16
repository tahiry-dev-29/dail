import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/views/bloc/theme_view_model.dart';
import 'package:flutter/material.dart';

class ThemeModeSelector extends StatelessWidget {
  final int currentMode;
  const ThemeModeSelector({required this.currentMode, super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final colors = context.colors;
    final accent = colors.accent;
    final textMuted = colors.textSecondary;
    final isDark = colors.isDark;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ModeButton(
            icon: AppIcons.mobile(context),
            label: 'Système',
            isSelected: currentMode == 0,
            onTap: () => themeVM.setThemeMode(0),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
          ModeButton(
            icon: AppIcons.moon(context),
            label: 'Sombre',
            isSelected: currentMode == 1,
            onTap: () => themeVM.setThemeMode(1),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
          ModeButton(
            icon: AppIcons.sun(context),
            label: 'Clair',
            isSelected: currentMode == 2,
            onTap: () => themeVM.setThemeMode(2),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accent;
  final Color textMuted;
  final bool isDark;

  const ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.textMuted,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? accent : Colors.transparent;
    final fgColor = isSelected ? Colors.white : textMuted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: fgColor),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
