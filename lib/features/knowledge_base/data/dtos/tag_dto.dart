import 'package:isar_community/isar.dart';

part 'tag_dto.g.dart';

/// Isar collection for Tag entity
@collection
class TagDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String name;
  late String color;
  String? workspaceId;
  late DateTime createdAt;

  TagDTO();

  TagDTO.create({
    required this.uid,
    required this.name,
    required this.color,
    this.workspaceId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
