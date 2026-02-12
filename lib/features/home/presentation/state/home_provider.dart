import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/home/presentation/state/dashboard_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for dashboard card order to provide smooth reordering animations.
/// Uses the same hybrid Signal-Riverpod pattern as Task lists.
final dashboardOrderProvider =
    NotifierProvider<DashboardOrderNotifier, List<DashboardCard>>(() {
      return DashboardOrderNotifier();
    });

class DashboardOrderNotifier extends Notifier<List<DashboardCard>> {
  @override
  List<DashboardCard> build() {
    final viewModel = sl<DashboardViewModel>();
    final signal = viewModel.dashboardOrder;

    // Sync from Signal to Riverpod
    bool isFirstRun = true;
    final dispose = signal.subscribe((newValue) {
      if (isFirstRun) {
        return; // Skip initial fire to avoid reading uninitialized state
      }
      state = newValue.toList();
    });

    isFirstRun = false;
    ref.onDispose(dispose);

    return signal.value.toList();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex == newIndex) return;

    final currentOrder = [...state];
    final item = currentOrder.removeAt(oldIndex);
    currentOrder.insert(newIndex, item);

    // 1. Instant UI update via Riverpod for smooth animation
    state = currentOrder;

    // 2. Sync back to Signal (persists automatically in ViewModel)
    sl<DashboardViewModel>().dashboardOrder.value = currentOrder;
  }
}
