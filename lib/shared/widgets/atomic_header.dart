import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../features/home/logic/home_signals.dart';
import '../../features/notifications/ui/notifications_page.dart';
import '../../features/settings/ui/settings_page.dart';
import '../../features/settings/providers/theme_provider.dart';
import '../../features/planner/providers/task_selectors.dart';
import '../../core/theme/adaptive_colors.dart';
import 'glass_container.dart';

class AtomicHeader extends ConsumerWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(now);
    final colors = context.colors;
    final progress = ref.watch(taskProgressProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20,
      ), // Slightly reduced horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date & Branding (LEFT)
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
                    fontSize: 24, // Slightly reduced base size
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Outfit',
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.accent.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'DAILY DATA',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Minimum spacing between left and right
          // Actions (RIGHT - 3 Widgets)
          Row(
            children: [
              // 1. Notification Bell
              _HeaderIconButton(
                icon: FontAwesomeIcons.bell,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
                hasBadge: true,
              ),
              const SizedBox(width: 12),

              // 2. Settings
              _HeaderIconButton(
                icon: FontAwesomeIcons.sliders,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
              ),
              const SizedBox(width: 12),

              // 3. Animated Daily Progress
              GestureDetector(
                onTap: () => triggerConfetti.value++,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: getAdaptedDuration(
                    const Duration(milliseconds: 1000),
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, _) {
                    final displayPercentage = (val * 100).toInt();
                    return GlassContainer(
                      borderRadius: 50,
                      padding: const EdgeInsets.all(4),
                      color: colors.surface,
                      borderColor: colors.border,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 34,
                                height: 34,
                                child: CircularProgressIndicator(
                                  value: val,
                                  backgroundColor: colors.textSecondary
                                      .withValues(alpha: 0.1),
                                  color: colors.accent,
                                  strokeWidth: 3.5,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "$displayPercentage%",
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends ConsumerWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          GlassContainer(
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
                  color: context.colors.accent,
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
    );
  }
}
