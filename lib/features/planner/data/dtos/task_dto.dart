import 'package:daily_os/features/planner/data/dtos/subtask_dto.dart';
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
  late List<SubTaskDTO> subtasks;
  late List<String> tagIds;
  late String? workspaceId;
  late String? folderId;
  String iconEmoji = '📝';

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
    this.subtasks = const [],
    this.tagIds = const [],
    this.workspaceId,
    this.folderId,
    this.iconEmoji = '📝',
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
      subtasks: entity.subtasks.map((st) => SubTaskDTO.fromEntity(st)).toList(),
      tagIds: entity.tagIds,
      workspaceId: entity.workspaceId,
      folderId: entity.folderId,
      iconEmoji: entity.iconEmoji,
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
      subtasks: subtasks.map((dto) => dto.toEntity()).toList(),
      tagIds: tagIds,
      workspaceId: workspaceId,
      folderId: folderId,
      iconEmoji: iconEmoji,
    );
  }
}
