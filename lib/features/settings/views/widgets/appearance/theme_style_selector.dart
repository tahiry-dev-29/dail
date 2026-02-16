import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/views/bloc/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ThemeStyleSelector extends StatelessWidget {
  const ThemeStyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final currentStyle = themeVM.themeStyle.watch(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Style Visuel",
            style: context.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _StyleCard(
                title: "Glassmorphism",
                description: "Effets de transparence et flou premium.",
                isSelected: currentStyle == ThemeStyle.glass,
                onTap: () => themeVM.setThemeStyle(ThemeStyle.glass),
                icon: Icons.blur_on,
              ),
            ),
            Expanded(
              child: _StyleCard(
                title: "Classique",
                description: "Interface solide, sobre et performante.",
                isSelected: currentStyle == ThemeStyle.classic,
                onTap: () => themeVM.setThemeStyle(ThemeStyle.classic),
                icon: Icons.rounded_corner,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StyleCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _StyleCard({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 20,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        borderColor: isSelected ? colors.accent : colors.border,
        color: isSelected ? colors.accent.withValues(alpha: 0.1) : null,
        useCustomBackground: false,
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? colors.accent : colors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.accent : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(
                color: colors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
