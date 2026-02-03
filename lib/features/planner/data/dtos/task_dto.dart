import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:isar_community/isar.dart';

part 'task_dto.g.dart';

@collection
class TaskDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String name;
  late String description;
  late String time;
  late bool isDone;
  late DateTime? date;
  late DateTime? deadline;
  late bool isFavorite;
  late bool isIgnored;

  // We will store subtasks as a separate collection linked by taskUid
  // or use embedded if prefered. Senior refactor prefers normalized or explicit linking for large datasets.
  // For now, let's keep it simple and flat.

  TaskDTO();

  TaskDTO.create({
    required this.uid,
    required this.name,
    this.description = '',
    required this.time,
    this.isDone = false,
    this.date,
    this.deadline,
    this.isFavorite = false,
    this.isIgnored = false,
  });

  factory TaskDTO.fromEntity(TaskEntity entity) {
    return TaskDTO.create(
      uid: entity.id,
      name: entity.name,
      description: entity.description,
      time: entity.time,
      isDone: entity.isDone,
      date: entity.date,
      deadline: entity.deadline,
      isFavorite: entity.isFavorite,
      isIgnored: entity.isIgnored,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: uid,
      name: name,
      description: description,
      time: time,
      isDone: isDone,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
      isIgnored: isIgnored,
      subtasks: [], // Subtasks will be loaded separately
    );
  }
}
