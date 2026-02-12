import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AtomicNavBar extends StatelessWidget {
  const AtomicNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = sl<HomeViewModel>();
    final current = homeVM.currentTab.watch(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: colors.surface.withValues(alpha: 0.4),
        child: Container(
          height: 70,
          alignment: .center,
          child: Row(
            mainAxisAlignment: .spaceAround,
            children: [
              _NavButton(
                icon: AppIcons.home(context),
                label: 'Home',
                isActive: current == AppTabs.home.index,
                onTap: () => homeVM.switchTab(AppTabs.home.index),
                colors: colors,
              ),
              _NavButton(
                icon: AppIcons.planner(context),
                label: 'Workspace',
                isActive: current == AppTabs.workspace.index,
                onTap: () => homeVM.switchTab(AppTabs.workspace.index),
                colors: colors,
              ),
              _NavButton(
                icon: AppIcons.calendar(context),
                label: 'Mois',
                isActive: current == AppTabs.calendar.index,
                onTap: () => homeVM.switchTab(AppTabs.calendar.index),
                colors: colors,
              ),
              _NavButton(
                icon: AppIcons.assistant(context),
                label: 'Assistant',
                isActive: current == AppTabs.aiChat.index,
                activeColor: colors.ai,
                onTap: () => homeVM.switchTab(AppTabs.aiChat.index),
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onTap;
  final AdaptiveColors colors;

  /// Local signal for press state — ultra-fast reactivity.
  final Signal<bool> _isPressed = signal(false);

  _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    this.activeColor,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final pressed = _isPressed.watch(context);
    final color = isActive
        ? (activeColor ?? colors.accent)
        : colors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) {
          _isPressed.value = true;
          HapticFeedback.lightImpact();
        },
        onTapUp: (_) => _isPressed.value = false,
        onTapCancel: () => _isPressed.value = false,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? .bold : .normal,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
