import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
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
        child: Container(
          height: 70,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                label: 'Planner',
                isActive: current == AppTabs.planner.index,
                onTap: () => homeVM.switchTab(AppTabs.planner.index),
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
                icon: Icons.book_outlined,
                label: 'Docs',
                isActive: current == AppTabs.knowledge.index,
                onTap: () => homeVM.switchTab(AppTabs.knowledge.index),
                colors: colors,
              ),
              _NavButton(
                icon: AppIcons.assistant(context),
                label: 'Assistant',
                isActive: current == AppTabs.aiChat.index,
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
  final VoidCallback onTap;
  final AdaptiveColors colors;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? colors.accent : colors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
