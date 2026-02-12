import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';

/// Page entity - A document/note that contains blocks of content
class PageEntity {
  final String id;
  final String folderId;
  final String title;
  final String iconEmoji;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final List<BlockEntity> blocks;
  final List<PropertyEntity> properties;
  final int sortOrder;

  const PageEntity({
    required this.id,
    required this.folderId,
    required this.title,
    this.iconEmoji = '📄',
    this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.blocks = const [],
    this.properties = const [],
    this.sortOrder = 0,
  });

  /// Check if page has any content
  bool get isEmpty => blocks.isEmpty;

  /// Get preview text from first paragraph block
  String get preview {
    for (final block in blocks) {
      if (block.type == .paragraph) {
        final text = block.content['text'] as String?;
        if (text != null && text.isNotEmpty) {
          return text.length > 100 ? '${text.substring(0, 100)}...' : text;
        }
      }
    }
    return '';
  }

  PageEntity copyWith({
    String? id,
    String? folderId,
    String? title,
    String? iconEmoji,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    List<BlockEntity>? blocks,
    List<PropertyEntity>? properties,
    int? sortOrder,
  }) {
    return PageEntity(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      blocks: blocks ?? this.blocks,
      properties: properties ?? this.properties,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => id.hashCode ^ sortOrder.hashCode;
}
