import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/views/widgets/appearance/section_title.dart';
import 'package:daily_os/features/settings/views/bloc/theme_view_model.dart';
import 'package:daily_os/design_system/organisms/atomic_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class BackgroundSettings extends StatelessWidget {
  const BackgroundSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = sl<ThemeViewModel>();
    final type = themeVM.backgroundType.watch(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "PERSONNALISATION DU FOND"),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Tab Selector
              Container(
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _TabItem(
                      label: "Couleur",
                      isSelected: type == .solid,
                      onTap: () => themeVM.setBackgroundType(.solid),
                    ),
                    _TabItem(
                      label: "Dégradé",
                      isSelected: type == .gradient,
                      onTap: () => themeVM.setBackgroundType(.gradient),
                    ),
                    _TabItem(
                      label: "Pro Themes",
                      isSelected: type == .pro,
                      onTap: () => themeVM.setBackgroundType(.pro),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Content based on selection
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSelector(type, themeVM, context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelector(
    BackgroundType type,
    ThemeViewModel themeVM,
    BuildContext context,
  ) {
    switch (type) {
      case .solid:
        return _SolidColorPicker(themeVM: themeVM);
      case .gradient:
        return _GradientPicker(themeVM: themeVM);
      case .pro:
        return _ProThemePicker(themeVM: themeVM);
    }
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _SolidColorPicker extends StatelessWidget {
  final ThemeViewModel themeVM;
  const _SolidColorPicker({required this.themeVM});

  @override
  Widget build(BuildContext context) {
    final selected = themeVM.customSolidColor.watch(context);
    final presets = [
      const Color(0xFF0F172A),
      const Color(0xFFF0F4F8),
      const Color(0xFF1E293B),
      const Color(0xFFF8FAFC),
      const Color(0xFF020617),
      const Color(0xFF7C3AED),
      const Color(0xFF2563EB),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: presets.map((color) {
        final isSelected = selected.toARGB32() == color.toARGB32();
        return GestureDetector(
          onTap: () => themeVM.setCustomSolidColor(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GradientPicker extends StatelessWidget {
  final ThemeViewModel themeVM;
  const _GradientPicker({required this.themeVM});

  @override
  Widget build(BuildContext context) {
    final gradient = themeVM.customGradient.watch(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GradientTarget(
              label: "Start",
              color: gradient[0],
              onTap: () => _pickColor(context, 0, gradient),
            ),
            const SizedBox(width: 20),
            const Icon(Icons.arrow_forward, color: Colors.white24, size: 20),
            const SizedBox(width: 20),
            _GradientTarget(
              label: "End",
              color: gradient[1],
              onTap: () => _pickColor(context, 1, gradient),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: gradient),
          ),
          child: const Center(
            child: Text(
              "Aperçu du dégradé",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pickColor(BuildContext context, int index, List<Color> current) {
    AtomicColorPicker.show(
      context,
      initialColor: current[index],
      onColorChanged: (c) {
        final newGrad = List<Color>.from(current);
        newGrad[index] = c;
        themeVM.setCustomGradient(newGrad);
      },
      title: index == 0 ? "Couleur de départ" : "Couleur de fin",
    );
  }
}

class _GradientTarget extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GradientTarget({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.caption.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProThemePicker extends StatelessWidget {
  final ThemeViewModel themeVM;
  const _ProThemePicker({required this.themeVM});

  @override
  Widget build(BuildContext context) {
    final selectedId = themeVM.proThemeId.watch(context);
    final themes = [
      {
        'id': 'midnight',
        'name': 'Midnight',
        'colors': [const Color(0xFF0F172A), const Color(0xFF1E293B)],
      },
      {
        'id': 'arctic',
        'name': 'Arctic',
        'colors': [const Color(0xFFF0F4F8), const Color(0xFFD9E2EC)],
      },
      {
        'id': 'sunset',
        'name': 'Sunset',
        'colors': [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)],
      },
      {
        'id': 'neon',
        'name': 'Neon',
        'colors': [const Color(0xFF111827), const Color(0xFF4C1D95)],
      },
      {
        'id': 'default',
        'name': 'System',
        'colors': [Colors.blueGrey, Colors.blueGrey.shade800],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final t = themes[index];
        final isSelected = selectedId == t['id'];
        final colors = t['colors'] as List<Color>;

        return GestureDetector(
          onTap: () => themeVM.setProTheme(t['id'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.accent.withValues(alpha: 0.1)
                  : context.colors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? context.colors.accent : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: .topLeft,
                      end: .bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t['name'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? context.colors.accent
                        : context.colors.textPrimary,
                    fontWeight: isSelected ? .bold : .normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
