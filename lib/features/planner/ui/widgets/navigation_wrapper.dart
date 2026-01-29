import 'package:flutter/material.dart';

import 'package:daily_os/features/calendar/providers/calendar_provider.dart';
import 'package:daily_os/features/planner/ui/widgets/planner_page_wrapper.dart';
import 'package:daily_os/features/calendar/ui/calendar_view_screen.dart';


// --- NAVIGATION WRAPPER ---

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  final PageController _pageController = PageController();

  void _navigateToPlanner(DateTime date) {
    // 2026 Integration: Update global calendarState
    calendarState.selectedDate.value = date;

    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _navigateToCalendar() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CalendarViewScreen(onDateSelected: _navigateToPlanner),
          PlannerPageWrapper(onBack: _navigateToCalendar),
        ],
      ),
    );
  }
}
