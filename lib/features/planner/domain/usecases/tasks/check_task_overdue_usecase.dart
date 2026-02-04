import 'package:daily_os/features/planner/domain/entities/task_entity.dart';

/// Checks if a task is overdue (IA Auto-Ignore Logic)
class CheckTaskOverdueUseCase {
  /// Returns true if the task is overdue based on the provided [now] timestamp.
  bool call(TaskEntity t, DateTime now) {
    // Skip already handled states
    if (t.isDone || t.isIgnored) return false;

    // If no date, cannot be overdue (treat as valid)
    if (t.date == null) return false;

    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(t.date!.year, t.date!.month, t.date!.day);

    // Case 1: Task date is before today -> OVERDUE
    if (taskDate.isBefore(today)) {
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

          return taskDateTime.isBefore(now);
        }
      } catch (_) {
        // Silently fail or log
      }
    }

    // Case 3: Task date is in the future -> NOT overdue
    return false;
  }
}
