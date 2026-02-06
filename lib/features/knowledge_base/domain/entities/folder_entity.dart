import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';

/// Folder entity with recursive structure for nested folders
class FolderEntity {
  final String id;
  final String? parentId; // null = root folder
  final String workspaceId;
  final String name;
  final String iconEmoji;
  final String? coverColor;
  final int sortOrder;
  final bool isExpanded; // UI state
  final bool isDeleted; // Soft delete for trash
  final List<FolderEntity> children;
  final List<PageEntity> pages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FolderEntity({
    required this.id,
    this.parentId,
    required this.workspaceId,
    required this.name,
    this.iconEmoji = '📁',
    this.coverColor,
    this.sortOrder = 0,
    this.isExpanded = false,
    this.isDeleted = false,
    this.children = const [],
    this.pages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if this is a root folder
  bool get isRoot => parentId == null;

  /// Get the depth of the folder in the tree (for indentation)
  int get depth {
    // This would be calculated based on parent chain in practice
    return 0;
  }

  FolderEntity copyWith({
    String? id,
    String? parentId,
    String? workspaceId,
    String? name,
    String? iconEmoji,
    String? coverColor,
    int? sortOrder,
    bool? isExpanded,
    bool? isDeleted,
    List<FolderEntity>? children,
    List<PageEntity>? pages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      coverColor: coverColor ?? this.coverColor,
      sortOrder: sortOrder ?? this.sortOrder,
      isExpanded: isExpanded ?? this.isExpanded,
      isDeleted: isDeleted ?? this.isDeleted,
      children: children ?? this.children,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          parentId == other.parentId &&
          workspaceId == other.workspaceId &&
          name == other.name &&
          iconEmoji == other.iconEmoji &&
          coverColor == other.coverColor &&
          sortOrder == other.sortOrder &&
          isExpanded == other.isExpanded &&
          isDeleted == other.isDeleted &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      parentId.hashCode ^
      workspaceId.hashCode ^
      name.hashCode ^
      iconEmoji.hashCode ^
      coverColor.hashCode ^
      sortOrder.hashCode ^
      isExpanded.hashCode ^
      isDeleted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
