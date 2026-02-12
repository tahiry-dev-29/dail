import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/home/presentation/components/widgets/active_timer_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/gemini_assistant_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/monthly_stats_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/progress_stats_card.dart';
import 'package:daily_os/features/home/presentation/state/dashboard_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_provider.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVM = sl<HomeViewModel>();

    // Watch global dashboard order & local edit mode via signal
    final cards = ref.watch(dashboardOrderProvider);
    final isEditMode = homeVM.isDashboardEditMode.watch(context);

    void toggleEditMode() {
      HapticFeedback.mediumImpact();
      homeVM.isDashboardEditMode.value = !homeVM.isDashboardEditMode.value;
    }

    return GestureDetector(
      // Toggle on double tap on the background
      onDoubleTap: toggleEditMode,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            sliver: SliverReorderableList(
              itemCount: cards.length,
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(dashboardOrderProvider.notifier)
                    .reorder(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final card = cards[index];

                return Padding(
                  key: ValueKey('container_${card.name}'),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          // Navigate on tap
                          onTap: () {
                            if (isEditMode) return;
                            switch (card) {
                              case DashboardCard.geminiAssistant:
                                homeVM.switchTab(AppTabs.aiChat.index);
                                break;
                              case DashboardCard.activeTimer:
                                homeVM.switchTab(AppTabs.calendar.index);
                                break;
                              case DashboardCard.progressStats:
                                homeVM.switchTab(AppTabs.workspace.index);
                                break;
                              case DashboardCard.monthlyStats:
                                homeVM.switchTab(AppTabs.calendar.index);
                                break;
                            }
                          },
                          // Toggle on long press only when NOT in edit mode
                          // to avoid conflict with dragging
                          onLongPress: isEditMode ? null : toggleEditMode,
                          child: _buildCard(card),
                        ),
                      ),
                      // Icon visibility & Drag handle logic
                      if (isEditMode)
                        ReorderableDragStartListener(
                          index: index,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.grab,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8,
                              ),
                              child: Icon(
                                Icons.drag_indicator_rounded,
                                color: Colors.grey.withValues(alpha: 0.5),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCard(DashboardCard card) {
    switch (card) {
      case DashboardCard.geminiAssistant:
        return const GeminiAssistantCard();
      case DashboardCard.activeTimer:
        return const ActiveTimerCard();
      case DashboardCard.progressStats:
        return const ProgressStatsCard();
      case DashboardCard.monthlyStats:
        return const MonthlyStatsCard();
    }
  }
}
