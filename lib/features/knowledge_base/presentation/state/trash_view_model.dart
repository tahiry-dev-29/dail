import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/empty_trash_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/get_deleted_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/get_deleted_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/permanently_delete_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/permanently_delete_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/restore_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/restore_page_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel for Trash management
class TrashViewModel {
  // Dependencies
  final GetDeletedFoldersUseCase _getDeletedFoldersUseCase;
  final GetDeletedPagesUseCase _getDeletedPagesUseCase;
  final RestoreFolderUseCase _restoreFolderUseCase;
  final RestorePageUseCase _restorePageUseCase;
  final PermanentlyDeleteFolderUseCase _permanentlyDeleteFolderUseCase;
  final PermanentlyDeletePageUseCase _permanentlyDeletePageUseCase;
  final EmptyTrashUseCase _emptyTrashUseCase;

  // State
  final Signal<AsyncState<List<FolderEntity>>> _deletedFolders = signal(
    const AsyncLoading(),
  );
  final Signal<AsyncState<List<PageEntity>>> _deletedPages = signal(
    const AsyncLoading(),
  );

  // Public read-only access
  ReadonlySignal<AsyncState<List<FolderEntity>>> get deletedFolders =>
      _deletedFolders;
  ReadonlySignal<AsyncState<List<PageEntity>>> get deletedPages =>
      _deletedPages;

  TrashViewModel({
    required GetDeletedFoldersUseCase getDeletedFoldersUseCase,
    required GetDeletedPagesUseCase getDeletedPagesUseCase,
    required RestoreFolderUseCase restoreFolderUseCase,
    required RestorePageUseCase restorePageUseCase,
    required PermanentlyDeleteFolderUseCase permanentlyDeleteFolderUseCase,
    required PermanentlyDeletePageUseCase permanentlyDeletePageUseCase,
    required EmptyTrashUseCase emptyTrashUseCase,
  }) : _getDeletedFoldersUseCase = getDeletedFoldersUseCase,
       _getDeletedPagesUseCase = getDeletedPagesUseCase,
       _restoreFolderUseCase = restoreFolderUseCase,
       _restorePageUseCase = restorePageUseCase,
       _permanentlyDeleteFolderUseCase = permanentlyDeleteFolderUseCase,
       _permanentlyDeletePageUseCase = permanentlyDeletePageUseCase,
       _emptyTrashUseCase = emptyTrashUseCase;

  /// Load all deleted items
  Future<void> loadTrash() async {
    _deletedFolders.value = const AsyncLoading();
    _deletedPages.value = const AsyncLoading();

    try {
      final folders = await _getDeletedFoldersUseCase();
      _deletedFolders.value = AsyncData(folders);
    } catch (e, stack) {
      _deletedFolders.value = AsyncError(e, stack);
    }

    try {
      final pages = await _getDeletedPagesUseCase();
      _deletedPages.value = AsyncData(pages);
    } catch (e, stack) {
      _deletedPages.value = AsyncError(e, stack);
    }
  }

  /// Restore a folder
  Future<void> restoreFolder(String folderId) async {
    await _restoreFolderUseCase(folderId);

    // Optimistic update
    final current = _deletedFolders.value.value ?? [];
    _deletedFolders.value = AsyncData(
      current.where((f) => f.id != folderId).toList(),
    );
  }

  /// Restore a page
  Future<void> restorePage(String pageId) async {
    await _restorePageUseCase(pageId);

    // Optimistic update
    final current = _deletedPages.value.value ?? [];
    _deletedPages.value = AsyncData(
      current.where((p) => p.id != pageId).toList(),
    );
  }

  /// Permanently delete a folder
  Future<void> permanentlyDeleteFolder(String folderId) async {
    await _permanentlyDeleteFolderUseCase(folderId);

    // Optimistic update
    final current = _deletedFolders.value.value ?? [];
    _deletedFolders.value = AsyncData(
      current.where((f) => f.id != folderId).toList(),
    );
  }

  /// Permanently delete a page
  Future<void> permanentlyDeletePage(String pageId) async {
    await _permanentlyDeletePageUseCase(pageId);

    // Optimistic update
    final current = _deletedPages.value.value ?? [];
    _deletedPages.value = AsyncData(
      current.where((p) => p.id != pageId).toList(),
    );
  }

  /// Empty trash
  Future<void> emptyTrash() async {
    await _emptyTrashUseCase();
    _deletedFolders.value = AsyncData([]);
    _deletedPages.value = AsyncData([]);
  }

  /// Clear state
  void clear() {
    _deletedFolders.value = AsyncData([]);
    _deletedPages.value = AsyncData([]);
  }
}
