import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/create_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/delete_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/get_tags_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/update_tag_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for managing tags (CRUD)
class TagViewModel {
  final GetTagsUseCase _getTagsUseCase;
  final CreateTagUseCase _createTagUseCase;
  final UpdateTagUseCase _updateTagUseCase;
  final DeleteTagUseCase _deleteTagUseCase;

  // State
  final Signal<AsyncState<List<TagEntity>>> _tags = signal(
    const AsyncLoading(),
  );

  // Public read-only access
  ReadonlySignal<AsyncState<List<TagEntity>>> get tags => _tags;

  TagViewModel({
    required GetTagsUseCase getTagsUseCase,
    required CreateTagUseCase createTagUseCase,
    required UpdateTagUseCase updateTagUseCase,
    required DeleteTagUseCase deleteTagUseCase,
  }) : _getTagsUseCase = getTagsUseCase,
       _createTagUseCase = createTagUseCase,
       _updateTagUseCase = updateTagUseCase,
       _deleteTagUseCase = deleteTagUseCase;

  /// Load all tags (Global by default)
  Future<void> loadTags() async {
    _tags.value = const AsyncLoading();
    try {
      final list = await _getTagsUseCase();
      if (list.isEmpty) {
        await _seedDefaultTags();
        // Reload after seeding
        final seededList = await _getTagsUseCase();
        _tags.value = AsyncData(seededList);
      } else {
        _tags.value = AsyncData(list);
      }
    } catch (e, stack) {
      _tags.value = AsyncError(e, stack);
    }
  }

  Future<void> _seedDefaultTags() async {
    final defaults = [
      (name: 'Important and Utils', color: '#EF4444', priority: 1), // Red
      (name: 'Important ans Not Utils', color: '#3B82F6', priority: 2), // Blue
      (name: 'Not Important and Utils', color: '#F59E0B', priority: 3), // Amber
      (
        name: 'Not Imporant and not Utils',
        color: '#9CA3AF',
        priority: 4,
      ), // Grey
      (name: 'Pending', color: '#F97316', priority: 5), // Orange
      (name: 'Work', color: '#8B5CF6', priority: 6), // Violet
      (name: 'Personal', color: '#EC4899', priority: 7), // Pink
    ];

    for (final tag in defaults) {
      final entity = TagEntity(
        id: const Uuid().v4(),
        name: tag.name,
        color: tag.color,
        priority: tag.priority,
        createdAt: DateTime.now(),
      );
      await _createTagUseCase(entity);
    }
  }

  /// Create a new tag
  Future<void> createTag(TagEntity tag) async {
    try {
      await _createTagUseCase(tag);
      await loadTags();
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing tag
  Future<void> updateTag(TagEntity tag) async {
    try {
      await _updateTagUseCase(tag);
      await loadTags();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a tag
  Future<void> deleteTag(String id) async {
    try {
      await _deleteTagUseCase(id);
      await loadTags();
    } catch (e) {
      rethrow;
    }
  }
}
