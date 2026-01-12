import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/utils/glass_scaffold.dart';
import '../providers/theme_provider.dart';

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = themeModeSignal.watch(context);
    final accent = accentColorSignal.watch(context);
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _SectionTitle(title: 'MODE', color: textMuted),
                const SizedBox(height: 12),
                _ThemeModeSelector(
                  currentMode: mode,
                  surface: surface,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
                const SizedBox(height: 32),
                _SectionTitle(title: "COULEUR D'ACCENT", color: textMuted),
                const SizedBox(height: 12),
                _ColorPicker(selectedColor: accent, surface: surface),
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
  const _ColorPicker({required this.selectedColor, required this.surface});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: accentColors
            .map(
              (color) => _ColorChip(
                color: color,
                isSelected: selectedColor.toARGB32() == color.toARGB32(),
                onTap: () => setAccentColor(color),
              ),
            )
            .toList(),
      ),
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
