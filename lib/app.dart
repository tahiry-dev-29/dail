import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/logic/theme_provider.dart';
import 'package:daily_os/shared/widgets/main_layout.dart';

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
      theme: AppTheme.lightTheme(accent, fontFamily),
      darkTheme: AppTheme.darkTheme(accent, fontFamily),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('fr', '')],
      home: const MainLayout(),
    );
  }
}
