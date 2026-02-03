import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:isar_community/isar.dart';

part 'subtask_dto.g.dart';

@collection
class SubTaskDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String taskUid;

  late String name;
  late String description;
  late String time;
  late bool isDone;
  late DateTime? deadline;
  late bool isFavorite;

  SubTaskDTO();

  SubTaskDTO.create({
    required this.uid,
    required this.name,
    this.description = '',
    this.time = '00:00',
    this.isDone = false,
    this.deadline,
    this.isFavorite = false,
  });

  factory SubTaskDTO.fromEntity(SubTaskEntity entity) {
    return SubTaskDTO.create(
      uid: entity.id,
      name: entity.name,
      description: entity.description,
      time: entity.time,
      isDone: entity.isDone,
      deadline: entity.deadline,
      isFavorite: entity.isFavorite,
    );
  }

  SubTaskEntity toEntity() {
    return SubTaskEntity(
      id: uid,
      name: name,
      description: description,
      time: time,
      isDone: isDone,
      deadline: deadline,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'time': time,
      'isDone': isDone,
      'deadline': deadline?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory SubTaskDTO.fromJson(Map<String, dynamic> json) {
    return SubTaskDTO.create(
      uid: json['uid'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      time: json['time'] as String,
      isDone: (json['isDone'] as bool?) ?? false,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }
}
