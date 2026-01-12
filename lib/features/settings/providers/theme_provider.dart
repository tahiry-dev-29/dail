import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode: 0 = system, 1 = dark, 2 = light
final themeModeSignal = signal<int>(0);
final accentColorSignal = signal<Color>(Colors.blueAccent);

// Animation duration multiplier: 0.5 (fast) to 2.0 (slow), default 1.0
final animationDurationMultiplier = signal<double>(1.0);

// Custom Colors List
final customColorsSignal = signal<List<Color>>([]);

// Font selection: 'Outfit' (Default), 'Roboto', 'Inter', 'system'
final fontSignal = signal<String>('Outfit');

// Icon Style: 'fontAwesome' (Default), 'material', 'system'
final iconStyleSignal = signal<String>('fontAwesome');

// Base accent colors
final List<Color> baseAccentColors = [
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

// Computed list of all accent colors
final allAccentColors = Provider<List<Color>>((ref) {
  return [...baseAccentColors, ...customColorsSignal.value];
});

// Load theme settings from storage
Future<void> loadThemeSettings() async {
  final prefs = await SharedPreferences.getInstance();
  themeModeSignal.value = prefs.getInt('themeMode') ?? 0;

  final colorValue = prefs.getInt('accentColor');
  if (colorValue != null) {
    accentColorSignal.value = Color(colorValue);
  }

  animationDurationMultiplier.value = prefs.getDouble('animMultiplier') ?? 1.0;
  fontSignal.value = prefs.getString('fontFamily') ?? 'Outfit';
  iconStyleSignal.value = prefs.getString('iconStyle') ?? 'fontAwesome';

  final customColorValues = prefs.getStringList('customColors') ?? [];
  customColorsSignal.value = customColorValues
      .map((hex) => Color(int.parse(hex, radix: 16)))
      .toList();
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

// Helper to save custom colors
Future<void> _saveCustomColors() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    'customColors',
    customColorsSignal.value
        .map((c) => c.toARGB32().toRadixString(16))
        .toList(),
  );
}

// Add Custom Color
Future<void> addCustomColor(Color color) async {
  if (!customColorsSignal.value.any((c) => c.toARGB32() == color.toARGB32())) {
    customColorsSignal.value = [...customColorsSignal.value, color];
    await _saveCustomColors();
  }
  await setAccentColor(color);
}

// Set Animation Multiplier
Future<void> setAnimationMultiplier(double value) async {
  animationDurationMultiplier.value = value;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('animMultiplier', value);
}

// Set Font
Future<void> setFontFamily(String font) async {
  fontSignal.value = font;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fontFamily', font);
}

// Set Icon Style
Future<void> setIconStyle(String style) async {
  iconStyleSignal.value = style;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('iconStyle', style);
}

// Utility to get duration adapted to user settings
Duration getAdaptedDuration(Duration base) {
  return Duration(
    milliseconds: (base.inMilliseconds * animationDurationMultiplier.value)
        .toInt(),
  );
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
