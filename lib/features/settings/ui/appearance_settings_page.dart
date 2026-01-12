import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/utils/glass_scaffold.dart';
import '../providers/theme_provider.dart';
import '../../../../shared/utils/toast_service.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = themeModeSignal.watch(context);
    final accent = accentColorSignal.watch(context);
    final animMultiplier = animationDurationMultiplier.watch(context);
    final fontFamily = fontSignal.watch(context);
    final iconStyle = iconStyleSignal.watch(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textMuted = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black54;
    final surface = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);

    return GlassScaffold(
      body: Column(
        children: [
          _Header(
            onBack: () => Navigator.pop(context),
            textPrimary: textPrimary,
            textMuted: textMuted,
            surface: surface,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _SectionTitle(title: 'MODE DE THÈME', color: textMuted),
                const SizedBox(height: 12),
                _ThemeModeSelector(
                  currentMode: mode,
                  surface: surface,
                  textMuted: textMuted,
                  isDark: isDark,
                ),

                const SizedBox(height: 32),
                _SectionTitle(
                  title: "PERSONNALISATION COULEUR",
                  color: textMuted,
                ),
                const SizedBox(height: 12),
                _ColorPicker(selectedColor: accent, surface: surface, ref: ref),

                const SizedBox(height: 32),
                _SectionTitle(
                  title: "VITESSE DES ANIMATIONS",
                  color: textMuted,
                ),
                const SizedBox(height: 12),
                _AnimationSettings(
                  multiplier: animMultiplier,
                  surface: surface,
                  textMuted: textMuted,
                  accent: accent,
                ),

                const SizedBox(height: 32),
                _SectionTitle(title: "TYPOGRAPHIE & STYLE", color: textMuted),
                const SizedBox(height: 12),
                _ChoiceSelector(
                  title: 'Police d\'écriture',
                  value: fontFamily,
                  items: const ['Outfit', 'Roboto', 'Inter', 'system'],
                  onChanged: (val) => setFontFamily(val),
                  surface: surface,
                  textPrimary: textPrimary,
                  accent: accent,
                  isFont: true,
                ),
                const SizedBox(height: 12),
                _ChoiceSelector(
                  title: 'Style d\'icônes',
                  value: iconStyle,
                  items: const ['fontAwesome', 'material', 'system'],
                  onChanged: (val) => setIconStyle(val),
                  surface: surface,
                  textPrimary: textPrimary,
                  accent: accent,
                  isIcon: true,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final Color textPrimary;
  final Color textMuted;
  final Color surface;
  const _Header({
    required this.onBack,
    required this.textPrimary,
    required this.textMuted,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 14,
                color: textMuted,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Apparence',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final int currentMode;
  final Color surface;
  final Color textMuted;
  final bool isDark;
  const _ThemeModeSelector({
    required this.currentMode,
    required this.surface,
    required this.textMuted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _ModeButton(
            icon: FontAwesomeIcons.mobile,
            label: 'Système',
            isSelected: currentMode == 0,
            onTap: () => setThemeMode(0),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
          _ModeButton(
            icon: FontAwesomeIcons.moon,
            label: 'Sombre',
            isSelected: currentMode == 1,
            onTap: () => setThemeMode(1),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
          _ModeButton(
            icon: FontAwesomeIcons.sun,
            label: 'Clair',
            isSelected: currentMode == 2,
            onTap: () => setThemeMode(2),
            accent: accent,
            textMuted: textMuted,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accent;
  final Color textMuted;
  final bool isDark;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.textMuted,
    required this.isDark,
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

class _ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Color surface;
  final WidgetRef ref;
  const _ColorPicker({
    required this.selectedColor,
    required this.surface,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(allAccentColors);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...colors.map(
            (color) => _ColorChip(
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

class _ColorChip extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorChip({
    required this.color,
    required this.isSelected,
    required this.onTap,
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

class _AnimationSettings extends StatelessWidget {
  final double multiplier;
  final Color surface;
  final Color textMuted;
  final Color accent;

  const _AnimationSettings({
    required this.multiplier,
    required this.surface,
    required this.textMuted,
    required this.accent,
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
                    _SpeedChip(
                      label: '0.5x',
                      value: 0.5,
                      current: multiplier,
                      accent: accent,
                    ),
                    _SpeedChip(
                      label: '1.0x',
                      value: 1.0,
                      current: multiplier,
                      accent: accent,
                    ),
                    _SpeedChip(
                      label: '1.5x',
                      value: 1.5,
                      current: multiplier,
                      accent: accent,
                    ),
                    _SpeedChip(
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

class _SpeedChip extends StatelessWidget {
  final String label;
  final double value;
  final double current;
  final Color accent;

  const _SpeedChip({
    required this.label,
    required this.value,
    required this.current,
    required this.accent,
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

class _ChoiceSelector extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final Color surface;
  final Color textPrimary;
  final Color accent;
  final bool isFont;
  final bool isIcon;

  const _ChoiceSelector({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.surface,
    required this.textPrimary,
    required this.accent,
    this.isFont = false,
    this.isIcon = false,
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
