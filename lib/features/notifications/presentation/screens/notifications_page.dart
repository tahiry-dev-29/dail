import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/notifications/domain/entities/notification_entity.dart';
import 'package:daily_os/features/notifications/logic/notifications_provider.dart';
import 'package:daily_os/features/notifications/presentation/components/notification_header.dart';
import 'package:daily_os/features/notifications/presentation/components/notification_card.dart';
import 'package:daily_os/features/notifications/presentation/components/notification_section_title.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NotificationEntity> notifications = ref.watch(
      notificationsProvider,
    );
    final List<NotificationEntity> newNotifications = notifications
        .where((n) => n.isNew)
        .toList();
    final List<NotificationEntity> earlierNotifications = notifications
        .where((n) => !n.isNew)
        .toList();

    return GlassScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: NotificationHeader(
              onBack: () => Navigator.pop(context),
              onMarkAllRead: () =>
                  ref.read(notificationsProvider.notifier).markAllAsRead(),
            ),
          ),
          if (newNotifications.isNotEmpty) ...[
            const SliverPadding(
              padding: .symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: NotificationSectionTitle(title: 'NEW'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: .symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: .only(bottom: 12),
                    child: NotificationCard(
                      notification: newNotifications[index],
                    ),
                  ),
                  childCount: newNotifications.length,
                ),
              ),
            ),
          ],
          if (earlierNotifications.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverPadding(
              padding: .symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: NotificationSectionTitle(title: 'EARLIER'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: .symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: .only(bottom: 12),
                    child: NotificationCard(
                      notification: earlierNotifications[index],
                    ),
                  ),
                  childCount: earlierNotifications.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
