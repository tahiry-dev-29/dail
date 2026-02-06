import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AtomicColorPicker extends HookWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final String title;

  const AtomicColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    this.title = "Choisir une couleur",
  });

  static void show(
    BuildContext context, {
    required Color initialColor,
    required ValueChanged<Color> onColorChanged,
    String? title,
  }) {
    showDialog(
      context: context,
      builder: (context) => AtomicColorPicker(
        initialColor: initialColor,
        onColorChanged: onColorChanged,
        title: title ?? "Choisir une couleur",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedColor = useState(initialColor);
    final hexController = useTextEditingController(
      text:
          '#${initialColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
    );

    void updateHex(Color color) {
      final hex =
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
      if (hexController.text.toUpperCase() != hex) {
        hexController.text = hex;
      }
    }

    return AlertDialog(
      backgroundColor: colors.background,
      surfaceTintColor: colors.accent.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: TextStyle(color: colors.textPrimary, fontWeight: .bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: .min,
          children: [
            ColorPicker(
              pickerColor: selectedColor.value,
              onColorChanged: (color) {
                selectedColor.value = color;
                updateHex(color);
              },
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
              pickerAreaBorderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: hexController,
              decoration: InputDecoration(
                labelText: "Code HEX (AARRGGBB)",
                labelStyle: TextStyle(color: colors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.accent),
                ),
                prefixIcon: Icon(Icons.tag, color: colors.accent, size: 18),
              ),
              style: TextStyle(
                color: colors.textPrimary,
                fontFamily: 'monospace',
              ),
              onChanged: (val) {
                String hex = val.replaceFirst('#', '');
                if (hex.length == 8) {
                  try {
                    final color = Color(int.parse(hex, radix: 16));
                    selectedColor.value = color;
                  } catch (_) {}
                } else if (hex.length == 6) {
                  try {
                    final color = Color(int.parse('FF$hex', radix: 16));
                    selectedColor.value = color;
                  } catch (_) {}
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Annuler", style: TextStyle(color: colors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            onColorChanged(selectedColor.value);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text("Sélectionner"),
        ),
      ],
    );
  }
}
