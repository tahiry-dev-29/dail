import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/presentation/components/grid/calendar_grid.dart';
import 'package:daily_os/features/calendar/presentation/components/grid/calendar_header.dart';
import 'package:daily_os/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMonth = calendarState.selectedDate.watch(context);
    final colors = context.colors;
    final headerColor = colors.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // Calendar Card
            GlassCard(
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
                                style: TextStyle(
                                  color: headerColor,
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
