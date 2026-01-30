import 'package:daily_os/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsNotifier extends Notifier<List<NotificationEntity>> {
  @override
  List<NotificationEntity> build() {
    return [
      const NotificationEntity(
        id: '1',
        icon: Icons.auto_awesome,
        iconColor: Colors.blueAccent,
        title: 'AI Optimization',
        description: 'Your schedule has been optimized for maximum focus.',
        time: 'Just now',
      ),
      const NotificationEntity(
        id: '2',
        icon: Icons.access_time,
        iconColor: Colors.pinkAccent,
        title: 'Deep Work Session',
        description: 'Starting in 15 minutes. Prepare your environment.',
        time: '10 min ago',
      ),
      const NotificationEntity(
        id: '3',
        icon: Icons.emoji_events,
        iconColor: Colors.amber,
        title: 'Milestone Unlocked',
        description: "You've completed 5 tasks today! Keep up the momentum.",
        time: '1 hr ago',
      ),
      const NotificationEntity(
        id: '4',
        icon: Icons.calendar_today,
        iconColor: Colors.pinkAccent,
        title: 'Design Review',
        description: 'Upcoming event tomorrow at 10:00 AM.',
        time: '2 hrs ago',
      ),
      const NotificationEntity(
        id: '5',
        icon: Icons.show_chart,
        iconColor: Colors.purpleAccent,
        title: 'Pattern Detected',
        description: 'You are 20% more productive on Tuesday mornings.',
        time: '1 day ago',
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
