import 'package:signals_flutter/signals_flutter.dart';

// Notification settings with real functionality
final notificationSoundsEnabled = signal(true);
final notificationAlertsEnabled = signal(true);
final notificationRemindersEnabled = signal(true);
final reminderMinutesBefore = signal(15);

// App settings
final isDailyOsProEnabled = signal(true);
final isDarkModeEnabled = signal(true);
final isAIAdaptiveEnabled = signal(true);
final isCalendarSyncEnabled = signal(true);

// Helper to toggle all notifications
void toggleAllNotifications(bool value) {
  notificationSoundsEnabled.value = value;
  notificationAlertsEnabled.value = value;
  notificationRemindersEnabled.value = value;
}
