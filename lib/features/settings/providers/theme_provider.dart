import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode: 0 = system, 1 = dark, 2 = light
final themeModeSignal = signal<int>(0);
final accentColorSignal = signal<Color>(Colors.blueAccent);

// Available accent colors
final accentColors = [
  Colors.blueAccent,
  Colors.purpleAccent,
  Colors.pinkAccent,
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.amber,
  Colors.greenAccent,
  Colors.tealAccent,
  Colors.cyanAccent,
];

// Load theme settings from storage
Future<void> loadThemeSettings() async {
  final prefs = await SharedPreferences.getInstance();
  themeModeSignal.value = prefs.getInt('themeMode') ?? 0;
  final colorValue = prefs.getInt('accentColor');
  if (colorValue != null) {
    accentColorSignal.value = Color(colorValue);
  }
}

// Save theme mode
Future<void> setThemeMode(int mode) async {
  themeModeSignal.value = mode;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeMode', mode);
}

// Save accent color
Future<void> setAccentColor(Color color) async {
  accentColorSignal.value = color;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('accentColor', color.toARGB32());
}

// Get ThemeMode from signal
ThemeMode getThemeMode() {
  switch (themeModeSignal.value) {
    case 1:
      return ThemeMode.dark;
    case 2:
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
}
