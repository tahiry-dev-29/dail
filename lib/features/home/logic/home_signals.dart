import 'package:signals_flutter/signals_flutter.dart';

// Current active tab index
final currentTab = signal<int>(0);

// Tab names for clarity
enum AppTabs { home, planner, calendar, aiChat }

// Function to switch tabs
void switchTab(int index) {
  currentTab.value = index;
}

// UI Signals
final isSettingsOpen = signal<bool>(false);
final isChatOpen = signal<bool>(false);
final triggerConfetti = signal<int>(0); // Increment to trigger
