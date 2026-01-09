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
    this.subtasks = const [],
  });

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    bool? isDone,
    DateTime? date,
    DateTime? deadline,
    bool? isFavorite,
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
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
