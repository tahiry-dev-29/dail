import 'package:flutter/material.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:daily_os/features/settings/providers/theme_provider.dart';

class AnimationSettings extends StatelessWidget {
  final double multiplier;
  final Color surface;
  final Color textMuted;
  final Color accent;

  const AnimationSettings({
    required this.multiplier,
    required this.surface,
    required this.textMuted,
    required this.accent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vitesse choisie',
                style: TextStyle(color: textMuted, fontSize: 13),
              ),
              Text(
                multiplier == 1.0
                    ? 'Standard'
                    : '${multiplier.toStringAsFixed(1)}x',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
                    SpeedChip(
                      label: '0.5x',
                      value: 0.5,
                      current: multiplier,
                      accent: accent,
                    ),
                    SpeedChip(
                      label: '1.0x',
                      value: 1.0,
                      current: multiplier,
                      accent: accent,
                    ),
                    SpeedChip(
                      label: '1.5x',
                      value: 1.5,
                      current: multiplier,
                      accent: accent,
                    ),
                    SpeedChip(
                      label: '2.0x',
                      value: 2.0,
                      current: multiplier,
                      accent: accent,
                    ),
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
  final Color accent;

  const SpeedChip({
    required this.label,
    required this.value,
    required this.current,
    required this.accent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == current;
    return GestureDetector(
      onTap: () {
        setAnimationMultiplier(value);
        _showPreview(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
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
