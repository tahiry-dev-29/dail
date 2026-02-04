import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/create_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/delete_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/get_tags_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/update_tag_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

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

  /// Load all tags (optionally filtered by workspace)
  Future<void> loadTags({String? workspaceId}) async {
    _tags.value = const AsyncLoading();
    try {
      final list = await _getTagsUseCase(workspaceId: workspaceId);
      _tags.value = AsyncData(list);
    } catch (e, stack) {
      _tags.value = AsyncError(e, stack);
    }
  }

  /// Create a new tag
  Future<void> createTag(TagEntity tag) async {
    try {
      await _createTagUseCase(tag);
      await loadTags(workspaceId: tag.workspaceId);
    } catch (e) {
      // Handle error (maybe show toast via signal/service)
      rethrow;
    }
  }

  /// Update an existing tag
  Future<void> updateTag(TagEntity tag) async {
    try {
      await _updateTagUseCase(tag);
      await loadTags(workspaceId: tag.workspaceId);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a tag
  Future<void> deleteTag(String id, {String? workspaceId}) async {
    try {
      await _deleteTagUseCase(id);
      await loadTags(workspaceId: workspaceId);
    } catch (e) {
      rethrow;
    }
  }
}
