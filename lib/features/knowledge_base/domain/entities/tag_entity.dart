/// Tag entity for categorizing pages and tasks
class TagEntity {
  final String id;
  final String name;
  final String color; // Hex color e.g. '#3B82F6'
  final int priority; // New priority field
  final String? workspaceId;
  final DateTime createdAt;

  const TagEntity({
    required this.id,
    required this.name,
    required this.color,
    this.priority = 0,
    this.workspaceId,
    required this.createdAt,
  });

  TagEntity copyWith({
    String? id,
    String? name,
    String? color,
    int? priority,
    String? workspaceId,
    DateTime? createdAt,
  }) {
    return TagEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      priority: priority ?? this.priority,
      workspaceId: workspaceId ?? this.workspaceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
