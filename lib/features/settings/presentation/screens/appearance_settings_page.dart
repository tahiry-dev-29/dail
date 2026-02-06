import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/animation_settings.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/background_settings.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/choice_selector.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/color_picker.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/header.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/section_title.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/theme_mode_selector.dart';
import 'package:daily_os/features/settings/presentation/components/appearance/theme_style_selector.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final mode = themeVM.themeMode.watch(context);
    final accent = themeVM.accentColor.watch(context);
    final animMultiplier = themeVM.animationDurationMultiplier.watch(context);
    final fontFamily = themeVM.fontFamily.watch(context);
    final iconStyle = themeVM.iconStyle.watch(context);

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
                const SizedBox(height: 24),
                const ThemeStyleSelector(),

                const SizedBox(height: 32),
                const BackgroundSettings(),

                const SizedBox(height: 32),
                const SectionTitle(title: "PERSONNALISATION ACCENT"),
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
                  onChanged: (val) => themeVM.setFontFamily(val),
                  isFont: true,
                ),
                const SizedBox(height: 12),
                ChoiceSelector(
                  title: 'Style d\'icônes',
                  value: iconStyle,
                  items: const [
                    'fontAwesome',
                    'material',
                    'cupertino',
                    'system',
                  ],
                  onChanged: (val) => themeVM.setIconStyle(val),
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
