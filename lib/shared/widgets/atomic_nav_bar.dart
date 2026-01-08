import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../features/home/logic/home_signals.dart';
import 'glass_container.dart';

class AtomicNavBar extends StatelessWidget {
  const AtomicNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch signal
    final current = currentTab.watch(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: GlassContainer(
        borderRadius: 28.0,
        color: const Color.fromRGBO(10, 10, 10, 0.7), // Heavy glass
        blur: 50.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavButton(
                icon: FontAwesomeIcons.house,
                label: 'Home',
                isActive: current == AppTabs.home.index,
                onTap: () => switchTab(AppTabs.home.index),
              ),
              _NavButton(
                icon: FontAwesomeIcons.barsStaggered, // stream equivalent
                label: 'Planner',
                isActive: current == AppTabs.planner.index,
                onTap: () => switchTab(AppTabs.planner.index),
              ),
              _NavButton(
                icon: FontAwesomeIcons.calendarDays,
                label: 'Mois',
                isActive: current == AppTabs.calendar.index,
                onTap: () => switchTab(AppTabs.calendar.index),
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

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
