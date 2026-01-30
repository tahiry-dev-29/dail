import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:daily_os/features/notifications/presentation/screens/notifications_page.dart';
import 'package:daily_os/features/settings/presentation/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AtomicHeader extends ConsumerWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = calendarState.selectedDate.watch(context);
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(selectedDate);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateStr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  'DAILY DATA',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _HeaderIconButton(
                icon: FontAwesomeIcons.bell,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
                hasBadge: true,
              ),
              const SizedBox(width: 12),
              _HeaderIconButton(
                icon: FontAwesomeIcons.sliders,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            GlassCard(
              borderRadius: 50,
              padding: const EdgeInsets.all(12),
              color: colors.surface,
              borderColor: colors.border,
              child: Icon(icon, color: colors.textSecondary, size: 18),
            ),
            if (hasBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.isDark ? Colors.black : Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
