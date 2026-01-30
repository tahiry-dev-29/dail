import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/settings/presentation/providers/theme_provider.dart';

import 'package:daily_os/features/settings/presentation/components/appearance/animation_settings.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/choice_selector.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/color_picker.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/header.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/section_title.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/theme_mode_selector.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = themeModeSignal.watch(context);
    final accent = accentColorSignal.watch(context);
    final animMultiplier = animationDurationMultiplier.watch(context);
    final fontFamily = fontSignal.watch(context);
    final iconStyle = iconStyleSignal.watch(context);

    return GlassScaffold(
      body: Column(
        children: [
          Header(onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const SectionTitle(title: 'MODE DE THÈME'),
                const SizedBox(height: 12),
                ThemeModeSelector(currentMode: mode),

                const SizedBox(height: 32),
                const SectionTitle(title: "PERSONNALISATION COULEUR"),
                const SizedBox(height: 12),
                ColorPicker(selectedColor: accent),

                const SizedBox(height: 32),
                const SectionTitle(title: "VITESSE DES ANIMATIONS"),
                const SizedBox(height: 12),
                AnimationSettings(multiplier: animMultiplier),

                const SizedBox(height: 32),
                const SectionTitle(title: "TYPOGRAPHIE & STYLE"),
                const SizedBox(height: 12),
                ChoiceSelector(
                  title: 'Police d\'écriture',
                  value: fontFamily,
                  items: const ['Outfit', 'Roboto', 'Inter', 'system'],
                  onChanged: (val) => setFontFamily(val),
                  isFont: true,
                ),
                const SizedBox(height: 12),
                ChoiceSelector(
                  title: 'Style d\'icônes',
                  value: iconStyle,
                  items: const ['fontAwesome', 'material', 'system'],
                  onChanged: (val) => setIconStyle(val),
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
