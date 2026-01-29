import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:daily_os/features/calendar/providers/calendar_provider.dart';
import 'package:daily_os/features/planner/ui/planner_screen.dart';


class PlannerPageWrapper extends ConsumerWidget {
  final VoidCallback onBack;

  const PlannerPageWrapper({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2026 Fix: Watch the signal to trigger rebuilds
    final selectedDate = calendarState.selectedDate.watch(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('d MMMM yyyy', 'fr_FR').format(selectedDate)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: onBack,
        ),
      ),
      // ValueKey forces rebuild when date changes
      body: PlannerScreen(key: ValueKey(selectedDate)),
    );
  }
}
