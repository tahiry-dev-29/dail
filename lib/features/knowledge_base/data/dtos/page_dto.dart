import 'package:isar_community/isar.dart';

part 'page_dto.g.dart';

/// Isar collection for Page entity
@collection
class PageDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String folderUid;

  late String title;
  late String iconEmoji;
  String? coverImageUrl;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isDeleted;
  late int sortOrder;

  PageDTO();

  PageDTO.create({
    required this.uid,
    required this.folderUid,
    required this.title,
    this.iconEmoji = '📄',
    this.coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isDeleted = false,
    this.sortOrder = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
