/// Property types for dynamic page metadata
enum PropertyType {
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

/// Priority levels for pages
enum PriorityLevel { none, low, medium, high, urgent }

/// Property entity - Dynamic metadata for pages
///
/// Value types by PropertyType:
/// - tags: `List<String>`
/// - date: DateTime
/// - priority: PriorityLevel
/// - status: String
/// - number: double
/// - text: String
/// - checkbox: bool
/// - select: String
/// - multiSelect: `List<String>`
class PropertyEntity {
  final String id;
  final String pageId;
  final String name;
  final PropertyType type;
  final dynamic value;

  const PropertyEntity({
    required this.id,
    required this.pageId,
    required this.name,
    required this.type,
    this.value,
  });

  /// Create a tags property
  factory PropertyEntity.tags({
    required String id,
    required String pageId,
    String name = 'Tags',
    List<String> tags = const [],
  }) {
    return PropertyEntity(
      id: id,
      pageId: pageId,
      name: name,
      type: .tags,
      value: tags,
    );
  }

  /// Create a date property
  factory PropertyEntity.date({
    required String id,
    required String pageId,
    String name = 'Due Date',
    DateTime? date,
  }) {
    return PropertyEntity(
      id: id,
      pageId: pageId,
      name: name,
      type: .date,
      value: date,
    );
  }

  /// Create a priority property
  factory PropertyEntity.priority({
    required String id,
    required String pageId,
    String name = 'Priority',
    PriorityLevel priority = .none,
  }) {
    return PropertyEntity(
      id: id,
      pageId: pageId,
      name: name,
      type: .priority,
      value: priority,
    );
  }

  /// Get value as tags list
  List<String> get tagsValue {
    if (value is List) {
      return (value as List).cast<String>();
    }
    return [];
  }

  /// Get value as date
  DateTime? get dateValue => value as DateTime?;

  /// Get value as priority
  PriorityLevel get priorityValue {
    if (value is PriorityLevel) return value as PriorityLevel;
    return .none;
  }

  PropertyEntity copyWith({
    String? id,
    String? pageId,
    String? name,
    PropertyType? type,
    dynamic value,
  }) {
    return PropertyEntity(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
