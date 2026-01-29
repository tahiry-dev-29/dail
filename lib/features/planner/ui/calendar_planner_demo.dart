import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:daily_os/features/planner/providers/task_provider.dart';
import 'package:daily_os/features/planner/data/task_model.dart';
import 'package:daily_os/features/planner/ui/widgets/navigation_wrapper.dart';

// --- MAIN APP (Demo Entry Point) ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const ProviderScope(child: CalendarPlannerApp()));
}

class CalendarPlannerApp extends ConsumerWidget {
  const CalendarPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return CalendarControllerProvider<Task>(
      controller: EventController<Task>()..addAll(_convertToEvents(tasks)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F0F0F),
          primaryColor: Colors.blueAccent,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
        locale: const Locale('fr', 'FR'),
        home: const NavigationWrapper(),
      ),
    );
  }

  List<CalendarEventData<Task>> _convertToEvents(List<Task> tasks) {
    return tasks
        .where((task) => task.date != null)
        .map(
          (task) => CalendarEventData<Task>(
            date: task.date!,
            title: task.name,
            event: task,
          ),
        )
        .toList();
  }
}
