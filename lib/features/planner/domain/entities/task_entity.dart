import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';

class TaskEntity {
  final String id;
  final String name;
  final String description;
  final String time;
  final bool isDone;
  final DateTime? date;
  final DateTime? deadline;
  final bool isFavorite;
  final bool isIgnored;
  final List<SubTaskEntity> subtasks;
  final List<String> tagIds;
  final String? workspaceId;
  final String? folderId;
  final String iconEmoji;

  const TaskEntity({
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
    this.tagIds = const [],
    this.workspaceId,
    this.folderId,
    this.iconEmoji = '📝',
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

  TaskEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    bool? isDone,
    DateTime? date,
    DateTime? deadline,
    bool? isFavorite,
    bool? isIgnored,
    List<SubTaskEntity>? subtasks,
    List<String>? tagIds,
    String? workspaceId,
    String? folderId,
    String? iconEmoji,
  }) {
    return TaskEntity(
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
      tagIds: tagIds ?? this.tagIds,
      workspaceId: workspaceId ?? this.workspaceId,
      folderId: folderId ?? this.folderId,
      iconEmoji: iconEmoji ?? this.iconEmoji,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          time == other.time &&
          isDone == other.isDone &&
          date == other.date &&
          deadline == other.deadline &&
          isFavorite == other.isFavorite &&
          isIgnored == other.isIgnored &&
          workspaceId == other.workspaceId &&
          folderId == other.folderId &&
          iconEmoji == other.iconEmoji;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      time.hashCode ^
      isDone.hashCode ^
      date.hashCode ^
      deadline.hashCode ^
      isFavorite.hashCode ^
      isIgnored.hashCode ^
      workspaceId.hashCode ^
      folderId.hashCode ^
      iconEmoji.hashCode;
}
