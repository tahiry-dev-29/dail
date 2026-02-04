/// Block types for the rich content editor
enum BlockType {
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

/// Block entity - A single content block in a page
/// Content is stored as JSON Map for flexibility
///
/// Content examples by type:
/// - paragraph: {"text": "Hello world", "formatting": [...]}
/// - heading1/2/3: {"text": "Title"}
/// - checklist: {"items": [{"text": "Item 1", "checked": false}, ...]}
/// - image: {"url": "...", "caption": "...", "width": 300}
/// - quote: {"text": "Quote text", "author": "..."}
/// - code: {"code": "...", "language": "dart"}
class BlockEntity {
  final String id;
  final String pageId;
  final BlockType type;
  final Map<String, dynamic> content;
  final int sortOrder;

  const BlockEntity({
    required this.id,
    required this.pageId,
    required this.type,
    this.content = const {},
    this.sortOrder = 0,
  });

  /// Create a new paragraph block
  factory BlockEntity.paragraph({
    required String id,
    required String pageId,
    String text = '',
    int sortOrder = 0,
  }) {
    return BlockEntity(
      id: id,
      pageId: pageId,
      type: .paragraph,
      content: {'text': text},
      sortOrder: sortOrder,
    );
  }

  /// Create a new heading block
  factory BlockEntity.heading({
    required String id,
    required String pageId,
    required int level,
    String text = '',
    int sortOrder = 0,
  }) {
    final type = switch (level) {
      1 => BlockType.heading1,
      2 => BlockType.heading2,
      _ => BlockType.heading3,
    };
    return BlockEntity(
      id: id,
      pageId: pageId,
      type: type,
      content: {'text': text},
      sortOrder: sortOrder,
    );
  }

  /// Create a new checklist block
  factory BlockEntity.checklist({
    required String id,
    required String pageId,
    List<Map<String, dynamic>>? items,
    int sortOrder = 0,
  }) {
    return BlockEntity(
      id: id,
      pageId: pageId,
      type: .checklist,
      content: {
        'items':
            items ??
            [
              {'text': '', 'checked': false},
            ],
      },
      sortOrder: sortOrder,
    );
  }

  /// Create a new audio block
  factory BlockEntity.audio({
    required String id,
    required String pageId,
    required String path,
    int? durationMs, // Duration in milliseconds
    int sortOrder = 0,
  }) {
    return BlockEntity(
      id: id,
      pageId: pageId,
      type: BlockType.audio,
      content: {'path': path, 'duration': durationMs},
      sortOrder: sortOrder,
    );
  }

  /// Get text content (for paragraph, headings, etc.)
  String get text => content['text'] as String? ?? '';

  /// Get checklist items
  List<Map<String, dynamic>> get checklistItems {
    final items = content['items'];
    if (items is List) {
      return items.cast<Map<String, dynamic>>();
    }
    return [];
  }

  BlockEntity copyWith({
    String? id,
    String? pageId,
    BlockType? type,
    Map<String, dynamic>? content,
    int? sortOrder,
  }) {
    return BlockEntity(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      type: type ?? this.type,
      content: content ?? this.content,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
