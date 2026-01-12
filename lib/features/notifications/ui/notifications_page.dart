import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/glass_scaffold.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textMuted = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black54;
    final surface = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.08);

    return GlassScaffold(
      body: Column(
        children: [
          _NotificationsHeader(
            textPrimary: textPrimary,
            textMuted: textMuted,
            surface: surface,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _SectionTitle(
                  title: 'NEW',
                  textMuted: textMuted,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: FontAwesomeIcons.wandMagicSparkles,
                  iconColor: Colors.blueAccent,
                  title: 'AI Optimization',
                  description:
                      "I've reorganized your afternoon schedule to align with your energy levels.",
                  time: '2m',
                  isNew: true,
                  hasBorder: true,
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: FontAwesomeIcons.clock,
                  iconColor: Colors.pinkAccent,
                  title: 'Deep Work Session',
                  description:
                      'Starting in 15 minutes. Prepare your environment.',
                  time: '15m',
                  isNew: true,
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: 'EARLIER',
                  textMuted: textMuted,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: FontAwesomeIcons.trophy,
                  iconColor: Colors.amber,
                  title: 'Milestone Unlocked',
                  description:
                      "You've completed 5 tasks today! Keep up the momentum.",
                  time: '1h',
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: FontAwesomeIcons.calendarDays,
                  iconColor: Colors.pinkAccent,
                  title: 'Design Review',
                  description: 'Upcoming event tomorrow at 10:00 AM.',
                  time: '3h',
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: FontAwesomeIcons.chartLine,
                  iconColor: Colors.purpleAccent,
                  title: 'Pattern Detected',
                  description:
                      'You are 20% more productive on Tuesday mornings.',
                  time: '5h',
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final Color textPrimary;
  final Color textMuted;
  final Color surface;
  const _NotificationsHeader({
    required this.onBack,
    required this.textPrimary,
    required this.textMuted,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 14,
                color: textMuted,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'MARK ALL READ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: textMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(FontAwesomeIcons.checkDouble, size: 12, color: textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textMuted;
  final Color borderColor;
  const _SectionTitle({
    required this.title,
    required this.textMuted,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: borderColor)),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  final bool isNew;
  final bool hasBorder;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textMuted;

  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    this.isNew = false,
    this.hasBorder = false,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: hasBorder
            ? Border.all(color: iconColor.withValues(alpha: 0.5))
            : Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: textMuted, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(time, style: TextStyle(fontSize: 11, color: textMuted)),
              if (isNew) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
