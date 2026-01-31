import 'package:isar_community/isar.dart';

part 'folder_dto.g.dart';

/// Isar collection for Folder entity with recursive parent-child relationship
@collection
class FolderDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  /// Parent folder ID (null for root folders)
  @Index()
  String? parentUid;

  @Index()
  late String workspaceUid;

  late String name;
  late String iconEmoji;
  String? coverColor;
  late int sortOrder;
  late bool isDeleted;
  late DateTime createdAt;
  late DateTime updatedAt;

  FolderDTO();

  FolderDTO.create({
    required this.uid,
    this.parentUid,
    required this.workspaceUid,
    required this.name,
    this.iconEmoji = '📁',
    this.coverColor,
    this.sortOrder = 0,
    this.isDeleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
