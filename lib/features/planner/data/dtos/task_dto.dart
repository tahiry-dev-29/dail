import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/data/dtos/subtask_dto.dart';

class TaskDTO {
  final String id;
  final String name;
  final String description;
  final String time;
  final bool isDone;
  final DateTime? date;
  final DateTime? deadline;
  final bool isFavorite;
  final bool isIgnored;
  final List<SubTaskDTO> subtasks;

  const TaskDTO({
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

  factory TaskDTO.fromEntity(TaskEntity entity) {
    return TaskDTO(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      time: entity.time,
      isDone: entity.isDone,
      date: entity.date,
      deadline: entity.deadline,
      isFavorite: entity.isFavorite,
      isIgnored: entity.isIgnored,
      subtasks: entity.subtasks.map((st) => SubTaskDTO.fromEntity(st)).toList(),
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      name: name,
      description: description,
      time: time,
      isDone: isDone,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
      isIgnored: isIgnored,
      subtasks: subtasks.map((dto) => dto.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'time': time,
      'isDone': isDone,
      'date': date?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isFavorite': isFavorite,
      'isIgnored': isIgnored,
      'subtasks': subtasks.map((st) => st.toJson()).toList(),
    };
  }

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      time: json['time'] as String,
      isDone: (json['isDone'] as bool?) ?? false,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
      isIgnored: (json['isIgnored'] as bool?) ?? false,
      subtasks:
          (json['subtasks'] as List<dynamic>?)
              ?.map((st) => SubTaskDTO.fromJson(st as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
