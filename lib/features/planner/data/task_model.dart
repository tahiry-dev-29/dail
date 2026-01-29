import 'subtask_model.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final String time;
  final bool isDone;
  final DateTime? date;
  final DateTime? deadline;
  final bool isFavorite;
  final bool isIgnored;
  final List<SubTask> subtasks;

  const Task({
    required this.id,
    required this.name,
    this.description = '',
    required this.time,
    this.isDone = false,
    this.date,
    this.deadline,
    this.isFavorite = false,
    this.isIgnored = false,
    this.subtasks = const [],
  });

  bool get isOverdue {
    if (date == null) return false;

    final now = DateTime.now();
    final taskDate = DateTime(date!.year, date!.month, date!.day);
    final today = DateTime(now.year, now.month, now.day);

    if (taskDate.isBefore(today)) return true;

    if (taskDate.isAtSameMomentAs(today)) {
      try {
        final parts = time.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final taskTime = DateTime(now.year, now.month, now.day, hour, minute);
          return taskTime.isBefore(now);
        }
      } catch (_) {}
    }
    return false;
  }

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    bool? isDone,
    DateTime? date,
    DateTime? deadline,
    bool? isFavorite,
    bool? isIgnored,
    List<SubTask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
      date: date ?? this.date,
      deadline: deadline ?? this.deadline,
      isFavorite: isFavorite ?? this.isFavorite,
      isIgnored: isIgnored ?? this.isIgnored,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
