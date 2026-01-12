import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../providers/dashboard_provider.dart';
import 'widgets/gemini_assistant_card.dart';
import 'widgets/active_timer_card.dart';
import 'widgets/progress_stats_card.dart';
import 'widgets/monthly_stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local signal to toggle edit mode (icons visibility)
  final isEditMode = signal(false);

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

  void _toggleEditMode() {
    HapticFeedback.mediumImpact();
    isEditMode.value = !isEditMode.value;
  }

  @override
  Widget build(BuildContext context) {
    // Watch both global dashboard order and local edit mode state
    final cards = dashboardOrderSignal.watch(context);
    final showIcons = isEditMode.watch(context);

    return GestureDetector(
      // Toggle on double tap on the background
      onDoubleTap: _toggleEditMode,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            sliver: SliverReorderableList(
              itemCount: cards.length,
              onReorder: (old, newIdx) => reorderDashboardCards(old, newIdx),
              // Simple proxy without extra animations to avoid ghosting issues
              proxyDecorator: (child, index, animation) => child,
              itemBuilder: (context, index) {
                final card = cards[index];

                return Padding(
                  key: ValueKey('container_${card.name}'),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    // Toggle on long press on any card
                    onLongPress: _toggleEditMode,
                    child: Row(
                      children: [
                        Expanded(child: _buildCard(card)),

                        // Icon visibility logic
                        if (showIcons)
                          ReorderableDragStartListener(
                            index: index,
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: const Icon(
                                Icons.drag_indicator_rounded,
                                color: Colors.grey,
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
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
