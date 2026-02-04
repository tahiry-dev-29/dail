import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/features/home/presentation/components/widgets/active_timer_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/gemini_assistant_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/monthly_stats_card.dart';
import 'package:daily_os/features/home/presentation/components/widgets/progress_stats_card.dart';
import 'package:daily_os/features/home/presentation/state/dashboard_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    // Local state to toggle edit mode (icons visibility)
    final isEditMode = useState(false);

    final homeVM = sl<HomeViewModel>();
    final dashboardVM = sl<DashboardViewModel>();

    // Watch global dashboard order
    final cards = dashboardVM.dashboardOrder.watch(context);
    final showIcons = isEditMode.value;

    void toggleEditMode() {
      HapticFeedback.mediumImpact();
      isEditMode.value = !isEditMode.value;
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
              onReorder: (old, newIdx) => dashboardVM.reorderCards(old, newIdx),
              // Simple proxy without extra animations to avoid ghosting issues
              proxyDecorator: (child, index, animation) => child,
              itemBuilder: (context, index) {
                final card = cards[index];

                return Padding(
                  key: ValueKey('container_${card.name}'),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    // Navigate on tap
                    onTap: () {
                      if (showIcons) return; // Don't navigate in edit mode
                      switch (card) {
                        case DashboardCard.geminiAssistant:
                          homeVM.switchTab(AppTabs.aiChat.index);
                          break;
                        case DashboardCard.activeTimer: // Now Clock
                          homeVM.switchTab(AppTabs.calendar.index);
                          break;
                        case DashboardCard.progressStats:
                          homeVM.switchTab(AppTabs.planner.index);
                          break;
                        case DashboardCard.monthlyStats:
                          homeVM.switchTab(AppTabs.calendar.index);
                          break;
                      }
                    },
                    // Toggle on long press on any card
                    onLongPress: toggleEditMode,
                    child: Row(
                      children: [
                        Expanded(child: _buildCard(card)),

                        // Icon visibility logic
                        if (showIcons)
                          ReorderableDragStartListener(
                            index: index,
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(
                                AppIcons.dragHandle(context),
                                color: Colors.grey,
                                size: 18,
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
          Watch(
            (context) => SliverToBoxAdapter(
              child: SizedBox(height: homeVM.isNavBarVisible.value ? 100 : 20),
            ),
          ),
        ],
      ),
    );
  }
}
