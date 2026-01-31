import 'package:isar_community/isar.dart';

part 'workspace_dto.g.dart';

/// Isar collection for Workspace entity
@collection
class WorkspaceDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String name;
  late String iconEmoji;
  late DateTime createdAt;

  WorkspaceDTO();

  WorkspaceDTO.create({
    required this.uid,
    required this.name,
    this.iconEmoji = '📚',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
