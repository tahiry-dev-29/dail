import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../shared/widgets/glass_container.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMonth = calendarState.selectedDate.watch(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // Calendar Card
            GlassContainer(
              borderRadius: 30,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CalendarHeader(currentMonth: currentMonth),
                  const SizedBox(height: 20),
                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ["L", "M", "M", "J", "V", "S", "D"]
                        .map(
                          (day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  const CalendarGrid(),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
