import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';

class SubTaskDTO {
  final String id;
  final String name;
  final String description;
  final bool isDone;
  final String time;
  final DateTime? deadline;
  final bool isFavorite;

  const SubTaskDTO({
    required this.id,
    required this.name,
    this.description = '',
    this.isDone = false,
    this.time = '00:00',
    this.deadline,
    this.isFavorite = false,
  });

  factory SubTaskDTO.fromEntity(SubTaskEntity entity) {
    return SubTaskDTO(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isDone: entity.isDone,
      time: entity.time,
      deadline: entity.deadline,
      isFavorite: entity.isFavorite,
    );
  }

  SubTaskEntity toEntity() {
    return SubTaskEntity(
      id: id,
      name: name,
      description: description,
      isDone: isDone,
      time: time,
      deadline: deadline,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isDone': isDone,
      'time': time,
      'deadline': deadline?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory SubTaskDTO.fromJson(Map<String, dynamic> json) {
    return SubTaskDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      isDone: (json['isDone'] as bool?) ?? false,
      time: (json['time'] as String?) ?? '00:00',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }
}
