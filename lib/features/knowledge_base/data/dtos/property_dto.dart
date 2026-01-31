import 'package:isar_community/isar.dart';

part 'property_dto.g.dart';

/// Property type enumeration for Isar
enum PropertyTypeDTO {
  tags,
  date,
  priority,
  status,
  number,
  text,
  checkbox,
  select,
  multiSelect,
}

/// Isar collection for Property entity
@collection
class PropertyDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String pageUid;

  late String name;

  @enumerated
  late PropertyTypeDTO type;

  /// JSON value stored as string (parsed at runtime based on type)
  late String valueJson;

  PropertyDTO();

  PropertyDTO.create({
    required this.uid,
    required this.pageUid,
    required this.name,
    required this.type,
    this.valueJson = 'null',
  });
}
