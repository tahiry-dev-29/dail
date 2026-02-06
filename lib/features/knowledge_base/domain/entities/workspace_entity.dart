/// Workspace entity - Root container for knowledge base
class WorkspaceEntity {
  final String id;
  final String name;
  final String iconEmoji;
  final DateTime createdAt;

  const WorkspaceEntity({
    required this.id,
    required this.name,
    this.iconEmoji = '📚',
    required this.createdAt,
  });

  WorkspaceEntity copyWith({
    String? id,
    String? name,
    String? iconEmoji,
    DateTime? createdAt,
  }) {
    return WorkspaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iconEmoji == other.iconEmoji &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ iconEmoji.hashCode ^ createdAt.hashCode;
}
