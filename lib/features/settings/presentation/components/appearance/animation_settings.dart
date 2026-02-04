import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';

class AnimationSettings extends StatelessWidget {
  final double multiplier;

  const AnimationSettings({required this.multiplier, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.accent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vitesse choisie',
                style: context.caption.copyWith(color: colors.textSecondary),
              ),
              Text(
                multiplier == 1.0
                    ? 'Standard'
                    : '${multiplier.toStringAsFixed(1)}x',
                style: context.bodyMedium.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    SpeedChip(label: '0.5x', value: 0.5, current: multiplier),
                    SpeedChip(label: '1.0x', value: 1.0, current: multiplier),
                    SpeedChip(label: '1.5x', value: 1.5, current: multiplier),
                    SpeedChip(label: '2.0x', value: 2.0, current: multiplier),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpeedChip extends StatelessWidget {
  final String label;
  final double value;
  final double current;

  const SpeedChip({
    required this.label,
    required this.value,
    required this.current,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final colors = context.colors;
    final isSelected = value == current;
    return GestureDetector(
      onTap: () {
        themeVM.setAnimationMultiplier(value);
        _showPreview(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent
              : colors.textSecondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: context.caption.copyWith(
            color: isSelected ? Colors.white : colors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context) {
    ToastService.show(
      context,
      message: "Vitesse réglée à $label (Test d'animation)",
      type: ToastType.success,
      duration: const Duration(seconds: 2),
    );
  }
}
