import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/logic/trash_state.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Controller for Trash operations
class TrashController {
  /// Load all deleted items (folders and pages)
  static Future<void> loadDeletedItems() async {
    deletedFoldersSignal.value = AsyncLoading();
    deletedPagesSignal.value = AsyncLoading();

    try {
      final repo = knowledgeRepository.value;

      // Load in parallel
      final results = await Future.wait([
        repo.getDeletedFolders(),
        repo.getDeletedPages(),
      ]);

      deletedFoldersSignal.value = AsyncData(results[0] as List<FolderEntity>);
      deletedPagesSignal.value = AsyncData(results[1] as List<PageEntity>);
    } catch (e, stack) {
      deletedFoldersSignal.value = AsyncError(e, stack);
      deletedPagesSignal.value = AsyncError(e, stack);
    }
  }

  /// Restore a folder from trash
  static Future<void> restoreFolder(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.restoreFolder(id);
      await loadDeletedItems();
    } catch (e) {
      rethrow;
    }
  }

  /// Restore a page from trash
  static Future<void> restorePage(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.restorePage(id);
      await loadDeletedItems();
    } catch (e) {
      rethrow;
    }
  }

  /// Permanently delete a folder
  static Future<void> permanentlyDeleteFolder(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.permanentlyDeleteFolder(id);
      await loadDeletedItems();
    } catch (e) {
      rethrow;
    }
  }

  /// Permanently delete a page
  static Future<void> permanentlyDeletePage(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.permanentlyDeletePage(id);
      await loadDeletedItems();
    } catch (e) {
      rethrow;
    }
  }

  /// Empty trash (delete all)
  static Future<void> emptyTrash() async {
    try {
      final repo = knowledgeRepository.value;
      await repo.emptyTrash();

      // Update local state to empty
      deletedFoldersSignal.value = AsyncData([]);
      deletedPagesSignal.value = AsyncData([]);
    } catch (e) {
      rethrow;
    }
  }
}
