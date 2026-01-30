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
}
