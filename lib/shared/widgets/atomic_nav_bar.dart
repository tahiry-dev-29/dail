import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../features/home/logic/home_signals.dart';

class AtomicNavBar extends StatelessWidget {
  const AtomicNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final current = currentTab.watch(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28.0),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
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
                  icon: FontAwesomeIcons.barsStaggered,
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
                _NavButton(
                  icon: FontAwesomeIcons.wandMagicSparkles,
                  label: 'Assistant',
                  isActive: current == AppTabs.aiChat.index,
                  onTap: () => switchTab(AppTabs.aiChat.index),
                ),
              ],
            ),
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
