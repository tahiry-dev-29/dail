import 'package:isar_community/isar.dart';

part 'block_dto.g.dart';

/// Block type enumeration for Isar
enum BlockTypeDTO {
  paragraph,
  heading1,
  heading2,
  heading3,
  checklist,
  image,
  divider,
  quote,
  code,
  audio,
}

/// Isar collection for Block entity
@collection
class BlockDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String pageUid;

  @enumerated
  late BlockTypeDTO type;

  /// JSON content stored as string (parsed at runtime)
  late String contentJson;

  late int sortOrder;

  BlockDTO();

  BlockDTO.create({
    required this.uid,
    required this.pageUid,
    required this.type,
    this.contentJson = '{}',
    this.sortOrder = 0,
  });
}
