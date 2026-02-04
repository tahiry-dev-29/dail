import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/core/router/app_router.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DailyOsApp extends ConsumerWidget {
  const DailyOsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = sl<ThemeViewModel>();
    // Watch Theme Mode Signal
    final accent = themeVM.accentColor.watch(context);
    final fontFamily = themeVM.fontFamily.watch(context);
    themeVM.themeMode.watch(context); // Watch for reactivity (value unused)
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'DailyOS',
      debugShowCheckedModeBanner: false,
      themeMode: themeVM.getThemeMode(),
      theme: AppTheme.lightTheme(accent, fontFamily),
      darkTheme: AppTheme.darkTheme(accent, fontFamily),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('fr', '')],
      routerConfig: router,
    );
  }
}
