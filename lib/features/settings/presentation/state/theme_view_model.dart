import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ThemeViewModel {
  final SharedPreferences _prefs;

  // Theme mode: 0 = system, 1 = dark, 2 = light
  final Signal<int> themeMode = signal<int>(0);
  final Signal<Color> accentColor = signal<Color>(Colors.blueAccent);

  // Animation duration multiplier: 0.5 (fast) to 2.0 (slow), default 1.0
  final Signal<double> animationDurationMultiplier = signal<double>(1.0);

  // Custom Colors List
  final Signal<List<Color>> customColors = signal<List<Color>>([]);

  // Font selection: 'Outfit' (Default), 'Roboto', 'Inter', 'system'
  final Signal<String> fontFamily = signal<String>('Outfit');

  // Icon Style: 'fontAwesome' (Default), 'material', 'system'
  final Signal<String> iconStyle = signal<String>('fontAwesome');

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

  ThemeViewModel(this._prefs) {
    _loadSettings();
  }

  void _loadSettings() {
    themeMode.value = _prefs.getInt('themeMode') ?? 0;

    final colorValue = _prefs.getInt('accentColor');
    if (colorValue != null) {
      accentColor.value = Color(colorValue);
    }

    animationDurationMultiplier.value =
        _prefs.getDouble('animMultiplier') ?? 1.0;
    fontFamily.value = _prefs.getString('fontFamily') ?? 'Outfit';
    iconStyle.value = _prefs.getString('iconStyle') ?? 'fontAwesome';

    final customColorValues = _prefs.getStringList('customColors') ?? [];
    customColors.value = customColorValues
        .map((hex) => Color(int.parse(hex, radix: 16)))
        .toList();
  }

  // Actions
  Future<void> setThemeMode(int mode) async {
    themeMode.value = mode;
    await _prefs.setInt('themeMode', mode);
  }

  Future<void> setAccentColor(Color color) async {
    accentColor.value = color;
    await _prefs.setInt('accentColor', color.toARGB32());
  }

  Future<void> addCustomColor(Color color) async {
    if (!customColors.value.any((c) => c.toARGB32() == color.toARGB32())) {
      customColors.value = [...customColors.value, color];
      await _prefs.setStringList(
        'customColors',
        customColors.value.map((c) => c.toARGB32().toRadixString(16)).toList(),
      );
    }
    await setAccentColor(color);
  }

  Future<void> setAnimationMultiplier(double value) async {
    animationDurationMultiplier.value = value;
    await _prefs.setDouble('animMultiplier', value);
  }

  Future<void> setFontFamily(String font) async {
    fontFamily.value = font;
    await _prefs.setString('fontFamily', font);
  }

  Future<void> setIconStyle(String style) async {
    iconStyle.value = style;
    await _prefs.setString('iconStyle', style);
  }

  // Utilities
  Duration getAdaptedDuration(Duration base) {
    return Duration(
      milliseconds: (base.inMilliseconds * animationDurationMultiplier.value)
          .toInt(),
    );
  }

  ThemeMode getThemeMode() {
    return switch (themeMode.value) {
      1 => ThemeMode.dark,
      2 => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  List<Color> getAllAccentColors() {
    return [...baseAccentColors, ...customColors.value];
  }
}
