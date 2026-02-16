import 'dart:async';

import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum AppTabs { home, workspace, calendar, aiChat }

class HomeViewModel {
  // Current active tab index
  final Signal<int> currentTab = signal<int>(0);

  // UI Signals
  final Signal<bool> isSettingsOpen = signal<bool>(false);
  final Signal<bool> isChatOpen = signal<bool>(false);
  final Signal<int> triggerConfetti = signal<int>(0);
  final Signal<bool> isNavBarVisible = signal<bool>(true);
  final Signal<bool> isAddTaskVisible = signal<bool>(false);
  final Signal<bool> isDashboardEditMode = signal<bool>(false);

  // Time Signal
  final Signal<String> timeString = signal(
    DateFormat('HH:mm').format(DateTime.now()),
  );

  Timer? _timer;

  HomeViewModel() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowStr = DateFormat('HH:mm').format(DateTime.now());
      if (timeString.value != nowStr) {
        timeString.value = nowStr;
      }
    });
  }

  // Tab names for clarity
  // AppTabs { home, planner, calendar, knowledge, aiChat }

  void switchTab(int index) {
    currentTab.value = index;
    // Reset nav bar visibility when switching tabs
    isNavBarVisible.value = true;
  }

  void dispose() {
    _timer?.cancel();
  }
}
