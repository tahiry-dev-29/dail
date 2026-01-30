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
    );
  }
}
