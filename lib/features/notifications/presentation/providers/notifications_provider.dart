import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_os/features/notifications/domain/entities/notification_entity.dart';

class NotificationsNotifier extends Notifier<List<NotificationEntity>> {
  @override
  List<NotificationEntity> build() {
    return [
      const NotificationEntity(
        id: '1',
        icon: FontAwesomeIcons.wandMagicSparkles,
        iconColor: Colors.blueAccent,
        title: 'AI Optimization',
        description:
            "I've reorganized your afternoon schedule to align with your energy levels.",
        time: '2m',
        isNew: true,
        hasBorder: true,
      ),
      const NotificationEntity(
        id: '2',
        icon: FontAwesomeIcons.clock,
        iconColor: Colors.pinkAccent,
        title: 'Deep Work Session',
        description: 'Starting in 15 minutes. Prepare your environment.',
        time: '15m',
        isNew: true,
      ),
      const NotificationEntity(
        id: '3',
        icon: FontAwesomeIcons.trophy,
        iconColor: Colors.amber,
        title: 'Milestone Unlocked',
        description: "You've completed 5 tasks today! Keep up the momentum.",
        time: '1h',
      ),
      const NotificationEntity(
        id: '4',
        icon: FontAwesomeIcons.calendarDays,
        iconColor: Colors.pinkAccent,
        title: 'Design Review',
        description: 'Upcoming event tomorrow at 10:00 AM.',
        time: '3h',
      ),
      const NotificationEntity(
        id: '5',
        icon: FontAwesomeIcons.chartLine,
        iconColor: Colors.purpleAccent,
        title: 'Pattern Detected',
        description: 'You are 20% more productive on Tuesday mornings.',
        time: '5h',
      ),
    ];
  }

  void markAllAsRead() {
    state = [
      for (final n in state)
        if (n.isNew) n.copyWith(isNew: false) else n,
    ];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationEntity>>(
      NotificationsNotifier.new,
    );
