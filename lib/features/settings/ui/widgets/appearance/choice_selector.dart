import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChoiceSelector extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final Color surface;
  final Color textPrimary;
  final Color accent;
  final bool isFont;
  final bool isIcon;

  const ChoiceSelector({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.surface,
    required this.textPrimary,
    required this.accent,
    this.isFont = false,
    this.isIcon = false,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textPrimary.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.map((item) {
                final isSelected = item == value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accent
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white24
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isIcon) ...[
                            _getIconForStyle(
                              item,
                              isSelected ? Colors.white : textPrimary,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            item == 'system' ? 'Système' : item,
                            style: TextStyle(
                              color: isSelected ? Colors.white : textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontFamily: isFont
                                  ? (item == 'system' ? null : item)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForStyle(String style, Color color) {
    IconData icon;
    switch (style) {
      case 'fontAwesome':
        icon = FontAwesomeIcons.fontAwesome;
        break;
      case 'material':
        icon = Icons.flutter_dash;
        break;
      default:
        icon = Icons.settings_suggest;
    }
    return Icon(icon, size: 14, color: color);
  }
}
