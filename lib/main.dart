import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/theme_engine.dart';
import 'core/utils/glass_scaffold.dart';
import 'features/ai_chat/ui/ai_chat_page.dart';
import 'features/calendar/ui/calendar_screen.dart';
import 'features/home/logic/home_signals.dart';
import 'features/home/providers/dashboard_provider.dart'; // Import Dashboard Provider
import 'features/home/ui/home_screen.dart';
import 'features/planner/ui/planner_screen.dart';
import 'features/planner/ui/widgets/add_task_inline.dart';
import 'features/settings/providers/theme_provider.dart';
import 'shared/widgets/atomic_header.dart';
import 'shared/widgets/atomic_nav_bar.dart';
import 'shared/widgets/safe_back_handler.dart';

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

    // Convert to ThemeMode enum
    final themeMode = switch (mode) {
      1 => ThemeMode.dark,
      2 => ThemeMode.light,
      _ => ThemeMode.system,
    };

    return MaterialApp(
      title: 'DailyOS AI',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppThemeEngine.lightTheme(accent),
      darkTheme: AppThemeEngine.darkTheme(accent),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final current = currentTab.watch(context);

    return SafeBackHandler(
      onBack: () {
        if (isAddTaskVisible.value) {
          isAddTaskVisible.value = false;
          return;
        }
        if (current != 0) {
          switchTab(0);
          return;
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: GlassScaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  if (current != AppTabs.aiChat.index) const AtomicHeader(),
                  Expanded(
                    child: IndexedStack(
                      index: current,
                      children: const [
                        HomeScreen(),
                        PlannerScreen(),
                        CalendarScreen(),
                        AiChatPage(),
                      ],
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AtomicNavBar(),
              ),
              const Positioned(
                bottom: 100,
                right: 16,
                child: FloatingAddTaskButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = isAddTaskVisible.watch(context);
    final current = currentTab.watch(context);

    if (isVisible || current != AppTabs.planner.index) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => isAddTaskVisible.value = true,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.purple500, AppColors.blue500],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.purple500.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(FontAwesomeIcons.plus, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
