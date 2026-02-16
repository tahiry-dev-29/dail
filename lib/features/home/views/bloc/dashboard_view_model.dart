import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

// Card types for the dashboard
enum DashboardCard { geminiAssistant, activeTimer, progressStats, monthlyStats }

class DashboardViewModel {
  final SharedPreferences _prefs;

  // Persistence Key
  static const String _kDashboardOrderKey = 'dashboard_card_order';

  // Signal for fast UI updates on reorder
  final Signal<List<DashboardCard>> dashboardOrder =
      signal<List<DashboardCard>>([
        DashboardCard.geminiAssistant,
        DashboardCard.activeTimer,
        DashboardCard.progressStats,
        DashboardCard.monthlyStats,
      ]);

  DashboardViewModel(this._prefs) {
    _initOrder();
  }

  // Initialize Persistence
  void _initOrder() {
    final saved = _prefs.getStringList(_kDashboardOrderKey);

    if (saved != null) {
      final loadedCards = saved
          .map((e) => DashboardCard.values.asNameMap()[e])
          .whereType<DashboardCard>()
          .toList();

      if (loadedCards.isNotEmpty) {
        // Ensure any NEW cards are also present
        final missingCards = DashboardCard.values
            .where((card) => !loadedCards.contains(card))
            .toList();

        dashboardOrder.value = [...loadedCards, ...missingCards];
        return;
      }
    }
  }

  // Reorder function (Auto-Save)
  void reorderCards(int oldIndex, int newIndex) {
    final list = [...dashboardOrder.value];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    // Update Signal
    dashboardOrder.value = list;

    // Persist
    _saveOrder(list);
  }

  Future<void> _saveOrder(List<DashboardCard> cards) async {
    final strings = cards.map((e) => e.name).toList();
    await _prefs.setStringList(_kDashboardOrderKey, strings);
  }
}
