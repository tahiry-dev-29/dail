import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:daily_os/shared/widgets/atomic_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;

  const ColorPicker({required this.selectedColor, super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final colors = themeVM.getAllAccentColors();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...colors.map(
            (color) => ColorChip(
              color: color,
              isSelected: selectedColor.toARGB32() == color.toARGB32(),
              onTap: () => themeVM.setAccentColor(color),
            ),
          ),
          // Plus button for custom color
          GestureDetector(
            onTap: () => _showColorPickerDialog(context, themeVM),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: Icon(
                AppIcons.add(context),
                color: Colors.white70,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, ThemeViewModel themeVM) {
    AtomicColorPicker.show(
      context,
      initialColor: selectedColor,
      onColorChanged: (color) => themeVM.addCustomColor(color),
      title: "Couleur d'accent",
    );
  }
}

class ColorChip extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorChip({
    required this.color,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12)]
              : null,
        ),
        child: isSelected
            ? Icon(AppIcons.check(context), color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
