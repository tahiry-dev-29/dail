import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SettingsViewModel {
  final SharedPreferences _prefs;

  // Notification settings
  final Signal<bool> notificationSoundsEnabled = signal(true);
  final Signal<bool> notificationAlertsEnabled = signal(true);
  final Signal<bool> notificationRemindersEnabled = signal(true);
  final Signal<int> reminderMinutesBefore = signal(15);

  // App settings
  final Signal<bool> isDailyOsProEnabled = signal(true);
  final Signal<bool> isAIAdaptiveEnabled = signal(true);
  final Signal<bool> isCalendarSyncEnabled = signal(true);

  SettingsViewModel(this._prefs) {
    _loadSettings();
  }

  void _loadSettings() {
    notificationSoundsEnabled.value = _prefs.getBool('notif_sounds') ?? true;
    notificationAlertsEnabled.value = _prefs.getBool('notif_alerts') ?? true;
    notificationRemindersEnabled.value =
        _prefs.getBool('notif_reminders') ?? true;
    reminderMinutesBefore.value = _prefs.getInt('reminder_minutes') ?? 15;

    isDailyOsProEnabled.value = _prefs.getBool('pro_enabled') ?? true;
    isAIAdaptiveEnabled.value = _prefs.getBool('ai_adaptive') ?? true;
    isCalendarSyncEnabled.value = _prefs.getBool('calendar_sync') ?? true;
  }

  // Actions
  Future<void> toggleNotificationSounds(bool value) async {
    notificationSoundsEnabled.value = value;
    await _prefs.setBool('notif_sounds', value);
  }

  Future<void> toggleNotificationAlerts(bool value) async {
    notificationAlertsEnabled.value = value;
    await _prefs.setBool('notif_alerts', value);
  }

  Future<void> toggleNotificationReminders(bool value) async {
    notificationRemindersEnabled.value = value;
    await _prefs.setBool('notif_reminders', value);
  }

  Future<void> setReminderMinutes(int minutes) async {
    reminderMinutesBefore.value = minutes;
    await _prefs.setInt('reminder_minutes', minutes);
  }

  Future<void> toggleAllNotifications(bool value) async {
    await toggleNotificationSounds(value);
    await toggleNotificationAlerts(value);
    await toggleNotificationReminders(value);
  }

  Future<void> togglePro(bool value) async {
    isDailyOsProEnabled.value = value;
    await _prefs.setBool('pro_enabled', value);
  }

  Future<void> toggleAIAdaptive(bool value) async {
    isAIAdaptiveEnabled.value = value;
    await _prefs.setBool('ai_adaptive', value);
  }

  Future<void> toggleCalendarSync(bool value) async {
    isCalendarSyncEnabled.value = value;
    await _prefs.setBool('calendar_sync', value);
  }
}
