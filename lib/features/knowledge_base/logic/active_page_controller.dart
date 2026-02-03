import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// Controller for Active Page operations
class ActivePageController {
  static void Function()? _pageLoaderDisposable;

  /// Initialize listeners
  static void init() {
    _pageLoaderDisposable?.call();
    _pageLoaderDisposable = effect(() {
      final pageId = activePageIdSignal.value;
      if (pageId != null) {
        _loadPage(pageId);
      } else {
        activePageSignal.value = AsyncData(null);
      }
    });
  }

  static Future<void> _loadPage(String pageId) async {
    activePageSignal.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final page = await repo.getPage(pageId);
      activePageSignal.value = AsyncData(page);
    } catch (e, stack) {
      activePageSignal.value = AsyncError(e, stack);
    }
  }

  /// Select a page to be active
  static void selectPage(String? pageId) {
    activePageIdSignal.value = pageId;
  }

  /// Create a new page
  static Future<void> createPage({
    required String title,
    required String folderId,
  }) async {
    try {
      final repo = knowledgeRepository.value;
      final newPage = PageEntity(
        id: const Uuid().v4(),
        folderId: folderId,
        title: title,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repo.createPage(newPage);

      selectPage(newPage.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Update current active page
  static Future<void> updatePage(PageEntity page) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.updatePage(page);

      // Update local signal if it's the active one
      if (activePageIdSignal.value == page.id) {
        activePageSignal.value = AsyncData(page);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update page title
  static Future<void> updateTitle(String newTitle) async {
    final currentState = activePageSignal.value;
    if (currentState is AsyncData<PageEntity?> && currentState.value != null) {
      final updatedPage = currentState.value!.copyWith(
        title: newTitle,
        updatedAt: DateTime.now(),
      );
      // Optimistic update
      activePageSignal.value = AsyncData(updatedPage);

      // Persist
      try {
        await updatePage(updatedPage);
      } catch (e) {
        // Rollback on error not implemented for brevity but recommended
        rethrow;
      }
    }
  }

  /// Delete a page
  static Future<void> deletePage(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.deletePage(id);

      if (activePageIdSignal.value == id) {
        activePageIdSignal.value = null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
