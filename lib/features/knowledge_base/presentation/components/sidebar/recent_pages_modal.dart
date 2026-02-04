import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/recent_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class RecentPagesModal extends StatelessWidget {
  const RecentPagesModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const RecentPagesModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final recentVM = sl<RecentListViewModel>();

    final recentState = recentVM.recentPages.watch(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Recent Pages',
                  style: context.h2.copyWith(color: colors.textPrimary),
                ),
              ],
            ),
          ),
          Expanded(
            child: recentState.map(
              data: (pages) {
                if (pages.isEmpty) {
                  return Center(
                    child: Text(
                      'No recent pages',
                      style: context.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return ListTile(
                      leading: Text(
                        page.iconEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        page.title,
                        style: context.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Last edited: ${_formatDate(page.updatedAt)}',
                        style: context.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        sl<ActivePageViewModel>().setActivePageId(page.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              error: (err, _) => Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
