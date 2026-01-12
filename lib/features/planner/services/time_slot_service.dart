/// Service to calculate time slots and interpolate times
class TimeSlotService {
  /// Get current time formatted as HH:mm
  static String getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// Interpolate a time between two other times
  /// Used for Drag & Drop reordering
  static String interpolateTime({String? prevTime, String? nextTime}) {
    // Defines defaults if ends of list
    if (prevTime == null && nextTime == null) return getCurrentTime();

    // Top of list: NextTime - 30 mins
    if (prevTime == null && nextTime != null) {
      return _addMinutes(nextTime, -30);
    }

    // Bottom of list: PrevTime + 30 mins
    if (prevTime != null && nextTime == null) {
      return _addMinutes(prevTime, 30);
    }

    // Between tasks: Average
    return _averageTime(prevTime!, nextTime!);
  }

  static String _addMinutes(String time, int minutes) {
    try {
      final parts = time.split(':').map(int.parse).toList();
      final totalMinutes = parts[0] * 60 + parts[1] + minutes;

      // Handle day wrap (simple clamp for now)
      final clampedMinutes = totalMinutes.clamp(0, 24 * 60 - 1);

      final h = clampedMinutes ~/ 60;
      final m = clampedMinutes % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    } catch (_) {
      return time;
    }
  }

  static String _averageTime(String t1, String t2) {
    try {
      final p1 = t1.split(':').map(int.parse).toList();
      final p2 = t2.split(':').map(int.parse).toList();

      final m1 = p1[0] * 60 + p1[1];
      final m2 = p2[0] * 60 + p2[1];

      final avg = (m1 + m2) ~/ 2;

      final h = avg ~/ 60;
      final m = avg % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    } catch (_) {
      return t1; // Fallback
    }
  }
}
