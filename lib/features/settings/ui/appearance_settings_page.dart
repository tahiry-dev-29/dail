import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/utils/glass_scaffold.dart';
import '../providers/theme_provider.dart';

import 'widgets/appearance/animation_settings.dart';
import 'widgets/appearance/choice_selector.dart';
import 'widgets/appearance/color_picker.dart';
import 'widgets/appearance/header.dart';
import 'widgets/appearance/section_title.dart';
import 'widgets/appearance/theme_mode_selector.dart';

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
          Header(
            onBack: () => Navigator.pop(context),
            textPrimary: textPrimary,
            textMuted: textMuted,
            surface: surface,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                SectionTitle(title: 'MODE DE THÈME', color: textMuted),
                const SizedBox(height: 12),
                ThemeModeSelector(
                  currentMode: mode,
                  surface: surface,
                  textMuted: textMuted,
                  isDark: isDark,
                ),

                const SizedBox(height: 32),
                SectionTitle(
                  title: "PERSONNALISATION COULEUR",
                  color: textMuted,
                ),
                const SizedBox(height: 12),
                ColorPicker(selectedColor: accent, surface: surface),

                const SizedBox(height: 32),
                SectionTitle(title: "VITESSE DES ANIMATIONS", color: textMuted),
                const SizedBox(height: 12),
                AnimationSettings(
                  multiplier: animMultiplier,
                  surface: surface,
                  textMuted: textMuted,
                  accent: accent,
                ),

                const SizedBox(height: 32),
                SectionTitle(title: "TYPOGRAPHIE & STYLE", color: textMuted),
                const SizedBox(height: 12),
                ChoiceSelector(
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
                ChoiceSelector(
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
