import 'package:signals_flutter/signals_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Card types for the dashboard
enum DashboardCard { geminiAssistant, activeTimer, progressStats, monthlyStats }

// Signal for fast UI updates on reorder
final dashboardOrderSignal = signal<List<DashboardCard>>([
  DashboardCard.geminiAssistant,
  DashboardCard.activeTimer,
  DashboardCard.progressStats,
  DashboardCard.monthlyStats,
]);

// Persistence Key
const String _kDashboardOrderKey = 'dashboard_card_order';

// Initialize Persistence
Future<void> initDashboardOrder() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getStringList(_kDashboardOrderKey);

  if (saved != null) {
    final loadedCards = saved
        .map((e) => DashboardCard.values.asNameMap()[e])
        .whereType<DashboardCard>() // Filter out nulls if enum names changed
        .toList();

    if (loadedCards.isNotEmpty) {
      // Ensure any NEW cards (added in updates) are also present if not in saved list
      // e.g. if we add 'weatherCard' later, it shouldn't be hidden forever
      final missingCards = DashboardCard.values
          .where((card) => !loadedCards.contains(card))
          .toList();

      dashboardOrderSignal.value = [...loadedCards, ...missingCards];
      return;
    }
  }

  // Default Order if no save
  dashboardOrderSignal.value = [
    DashboardCard.geminiAssistant,
    DashboardCard.activeTimer,
    DashboardCard.progressStats,
    DashboardCard.monthlyStats,
  ];
}

// Reorder function (Auto-Save)
void reorderDashboardCards(int oldIndex, int newIndex) {
  final list = [...dashboardOrderSignal.value];
  if (newIndex > oldIndex) newIndex -= 1;
  final item = list.removeAt(oldIndex);
  list.insert(newIndex, item);

  // Update Signal
  dashboardOrderSignal.value = list;

  // Persist
  _saveOrder(list);
}

Future<void> _saveOrder(List<DashboardCard> cards) async {
  final prefs = await SharedPreferences.getInstance();
  final strings = cards.map((e) => e.name).toList();
  await prefs.setStringList(_kDashboardOrderKey, strings);
}
