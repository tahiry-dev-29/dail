import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/core/theme/adaptive_colors.dart'; // Import AdaptiveColors
import 'package:daily_os/shared/widgets/glass_container.dart'; // Reuse GlassContainer for consistency
import '../../features/home/logic/home_signals.dart';

class AtomicNavBar extends StatelessWidget {
  const AtomicNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final current = currentTab.watch(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: GlassContainer(
        borderRadius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Force the container height by constraint in parent or SizedBox here?
        // GlassContainer wraps child size.
        // We'll wrap the Row in a Container with height 70.
        child: Container(
          height: 70,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavButton(
                icon: FontAwesomeIcons.house,
                label: 'Home',
                isActive: current == AppTabs.home.index,
                onTap: () => switchTab(AppTabs.home.index),
                colors: colors,
              ),
              _NavButton(
                icon: FontAwesomeIcons.barsStaggered,
                label: 'Planner',
                isActive: current == AppTabs.planner.index,
                onTap: () => switchTab(AppTabs.planner.index),
                colors: colors,
              ),
              _NavButton(
                icon: FontAwesomeIcons.calendarDays,
                label: 'Mois',
                isActive: current == AppTabs.calendar.index,
                onTap: () => switchTab(AppTabs.calendar.index),
                colors: colors,
              ),
              _NavButton(
                icon: FontAwesomeIcons.wandMagicSparkles,
                label: 'Assistant',
                isActive: current == AppTabs.aiChat.index,
                onTap: () => switchTab(AppTabs.aiChat.index),
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
    // Active Color: Neon Accent (Primary)
    // Inactive Color: TextSecondary (Slate-500)
    final color = isActive ? colors.accent : colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Hit target
      child: SizedBox(
        width: 60, // Ensure decent touch target
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
    );
  }
}
