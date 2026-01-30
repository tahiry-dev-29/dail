import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_os/features/settings/presentation/providers/theme_provider.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';

class ColorPicker extends ConsumerWidget {
  final Color selectedColor;

  const ColorPicker({required this.selectedColor, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(allAccentColors);

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
              onTap: () => setAccentColor(color),
            ),
          ),
          // Plus button for custom color
          GestureDetector(
            onTap: () => _showColorPickerDialog(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const Icon(
                FontAwesomeIcons.plus,
                color: Colors.white70,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Choisir une couleur',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selectionnez votre couleur d\'accent personnalisée',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          Colors.indigo,
                          Colors.lightBlue,
                          Colors.teal,
                          Colors.green,
                          Colors.lime,
                          Colors.yellow,
                          Colors.orange,
                          Colors.deepOrange,
                          Colors.brown,
                          Colors.blueGrey,
                          Colors.deepPurple,
                          Colors.pink,
                        ]
                        .map(
                          (c) => GestureDetector(
                            onTap: () {
                              addCustomColor(c);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
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
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
