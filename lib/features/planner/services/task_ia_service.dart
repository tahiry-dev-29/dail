import 'package:flutter/material.dart';
import '../data/task_model.dart';

class TaskIaService {
  /// Checks if a task is overdue (IA Auto-Ignore Logic)
  /// A task is overdue if:
  /// 1. Its date is in the past (before today)
  /// 2. Its date is today AND its time has already passed
  static bool isTaskOverdue(Task t, DateTime now) {
    // Skip already handled states
    if (t.isDone || t.isIgnored) return false;

    // If no date, cannot be overdue (treat as valid)
    if (t.date == null) return false;

    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(t.date!.year, t.date!.month, t.date!.day);

    // Case 1: Task date is before today -> OVERDUE
    if (taskDate.isBefore(today)) {
      debugPrint(
        '[IA] Task "${t.name}" is OVERDUE: date ${t.date} is before today $today',
      );
      return true;
    }

    // Case 2: Task date is today -> Check time
    if (taskDate.isAtSameMomentAs(today)) {
      try {
        final parts = t.time.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0].trim());
          final minute = int.parse(parts[1].trim());
          final taskDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          final isPastTime = taskDateTime.isBefore(now);

          if (isPastTime) {
            debugPrint(
              '[IA] Task "${t.name}" is OVERDUE: ${t.time} < ${now.hour}:${now.minute}',
            );
          }

          return isPastTime;
        }
      } catch (e) {
        debugPrint('[IA] Error parsing time for "${t.name}": $e');
      }
    }

    // Case 3: Task date is in the future -> NOT overdue
    return false;
  }
}
