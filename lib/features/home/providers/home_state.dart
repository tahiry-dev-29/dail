import 'dart:async';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeState {
  // Signal for current time string (HH:mm)
  final Signal<String> timeString = signal(
    DateFormat('HH:mm').format(DateTime.now()),
  );

  Timer? _timer;

  HomeState() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowStr = DateFormat('HH:mm').format(DateTime.now());
      if (timeString.value != nowStr) {
        timeString.value = nowStr;
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Global instance
final homeState = HomeState();
