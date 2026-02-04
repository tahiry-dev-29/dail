import 'package:signals_flutter/signals_flutter.dart';

class CalendarViewModel {
  // Current selected date (defaults to now)
  final Signal<DateTime> selectedDate = signal(DateTime.now());

  // Computed: Number of days in the currently selected month
  late final Computed<int> daysInMonth = computed(
    () =>
        DateTime(selectedDate.value.year, selectedDate.value.month + 1, 0).day,
  );

  // Computed: Weekday of the first day of the month (1 = Mon, 7 = Sun)
  late final Computed<int> firstDayOffset = computed(
    () =>
        DateTime(selectedDate.value.year, selectedDate.value.month, 1).weekday,
  );

  // Actions
  void nextMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
    );
  }

  void prevMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
    );
  }

  void selectDate(int day) {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      day,
    );
  }
}
