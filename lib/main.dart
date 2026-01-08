import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:signals_flutter/signals_flutter.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_colors.dart';
import 'core/utils/glass_scaffold.dart';
import 'features/ai_chat/ui/chat_overlay.dart';
import 'features/calendar/ui/calendar_screen.dart';
import 'features/home/logic/home_signals.dart';
import 'features/home/ui/home_screen.dart';
import 'features/planner/ui/planner_screen.dart';
import 'shared/widgets/atomic_header.dart';
import 'shared/widgets/atomic_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

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
    return MaterialApp(
      title: 'DailyOS AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.aiColor,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch current tab signal
    final current = currentTab.watch(context);

    return GlassScaffold(
      body: Stack(
        children: [
          // Main Content Layer
          Column(
            children: [
              const AtomicHeader(),
              Expanded(
                child: IndexedStack(
                  index: current,
                  children: const [
                    HomeScreen(),
                    PlannerScreen(),
                    CalendarScreen(),
                  ],
                ),
              ),
            ],
          ),

          // Dock (Bottom)
          const Positioned(bottom: 0, left: 0, right: 0, child: AtomicNavBar()),

          // Chat Overlay (Top Layer)
          const Positioned.fill(child: ChatOverlay()),

          // Floating Action Button for Chat (if closed)
          // We can add this if needed, but the card triggers it, and the dock is there.
          // HTML has a floating button too.
          Positioned(bottom: 100, right: 16, child: FloatingActionChatButton()),
        ],
      ),
    );
  }
}

class FloatingActionChatButton extends StatelessWidget {
  const FloatingActionChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isOpen = isChatOpen.watch(context);

    // Hide if open
    if (isOpen) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => isChatOpen.value = true,
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
              color: AppColors.purple500.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.auto_awesome, color: Colors.white),
        ),
      ),
    );
  }
}
