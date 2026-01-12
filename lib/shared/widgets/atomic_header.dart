import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../features/home/logic/home_signals.dart';
import '../../features/notifications/ui/notifications_page.dart';
import '../../features/settings/ui/settings_page.dart';
import '../../features/planner/providers/task_provider.dart';
import '../../core/theme/adaptive_colors.dart';
import 'glass_container.dart';

class AtomicHeader extends ConsumerWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks & State
    final now = DateTime.now();
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(now);
    final colors = context.colors;

    // Task Data for Progress
    final tasks = ref.watch(filteredTasksProvider);
    final total = tasks.length;
    final done = tasks.where((t) => t.isDone).length;
    final progress = total > 0 ? done / total : 0.0;
    final percentage = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date & Branding
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit', // Ensure font
                ),
              ),
              Row(
                children: [
                  Text(
                    'DAILYOS AI',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Actions
          Row(
            children: [
              // Notification Bell
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
                child: Stack(
                  children: [
                    GlassContainer(
                      borderRadius: 50,
                      padding: const EdgeInsets.all(12), // Larger touch target
                      color: colors.surface,
                      borderColor: colors.border,
                      child: Icon(
                        FontAwesomeIcons.bell,
                        color: colors.textSecondary,
                        size: 18,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
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
              const SizedBox(width: 12),

              // Settings Button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
                child: GlassContainer(
                  borderRadius: 50,
                  padding: const EdgeInsets.all(12),
                  color: colors.surface, // Use surface not hardcoded
                  borderColor: colors.border,
                  child: Icon(
                    FontAwesomeIcons.gear,
                    color: colors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Daily Progress Ring
              GestureDetector(
                onTap: () => triggerConfetti.value++,
                child: GlassContainer(
                  borderRadius: 50,
                  padding: const EdgeInsets.all(4), // Tight padding for ring
                  color: colors.surface,
                  borderColor: colors.border,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: colors.textSecondary.withValues(
                                alpha: 0.1,
                              ),
                              color: colors.accent,
                              strokeWidth: 3,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "$percentage%",
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
