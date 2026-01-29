import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/theme_engine.dart';
import 'features/home/providers/dashboard_provider.dart';
import 'features/settings/providers/theme_provider.dart';
import 'shared/widgets/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await loadThemeSettings(); // Load theme
  await initDashboardOrder(); // Load dashboard order

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: DailyOsApp()));
}

class DailyOsApp extends StatelessWidget {
  const DailyOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch Theme Mode Signal
    final mode = themeModeSignal.watch(context);
    final accent = accentColorSignal.watch(context);
    final fontFamily = fontSignal.watch(context);

    // Convert to ThemeMode enum
    ThemeMode getThemeMode() {
      return switch (mode) {
        1 => ThemeMode.dark,
        2 => ThemeMode.light,
        _ => ThemeMode.system,
      };
    }

    return MaterialApp(
      title: 'DailyOS',
      debugShowCheckedModeBanner: false,
      themeMode: getThemeMode(),
      theme: AppThemeEngine.lightTheme(accent, fontFamily),
      darkTheme: AppThemeEngine.darkTheme(accent, fontFamily),
      home: const MainLayout(),
    );
  }
}