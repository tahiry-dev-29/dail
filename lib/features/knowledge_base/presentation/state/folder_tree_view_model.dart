import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/create_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/delete_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_child_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_root_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/move_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/update_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_pages_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for Folder Tree operations
///
/// Replaces the static [FolderTreeController] with proper dependency injection.
class FolderTreeViewModel {
  // Dependencies
  final GetRootFoldersUseCase _getRootFoldersUseCase;
  final CreateFolderUseCase _createFolderUseCase;
  final UpdateFolderUseCase _updateFolderUseCase;
  final DeleteFolderUseCase _deleteFolderUseCase;
  final GetChildFoldersUseCase _getChildFoldersUseCase;
  final MoveFolderUseCase _moveFolderUseCase;
  final GetPagesUseCase _getPagesUseCase;

  // State
  final Signal<AsyncState<List<FolderEntity>>> _rootFolders = signal(
    const AsyncData([]),
  );
  final Signal<Set<String>> _expandedFolders = signal({});

  // Cache for lazy-loaded children and pages
  final Map<String, Signal<AsyncState<List<FolderEntity>>>> _childrenCache = {};
  final Map<String, Signal<AsyncState<List<PageEntity>>>> _pagesCache = {};

  // Public read-only access
  ReadonlySignal<AsyncState<List<FolderEntity>>> get rootFolders =>
      _rootFolders;
  ReadonlySignal<Set<String>> get expandedFolders => _expandedFolders;

  FolderTreeViewModel({
    required GetRootFoldersUseCase getRootFoldersUseCase,
    required CreateFolderUseCase createFolderUseCase,
    required UpdateFolderUseCase updateFolderUseCase,
    required DeleteFolderUseCase deleteFolderUseCase,
    required GetChildFoldersUseCase getChildFoldersUseCase,
    required MoveFolderUseCase moveFolderUseCase,
    required GetPagesUseCase getPagesUseCase,
  }) : _getRootFoldersUseCase = getRootFoldersUseCase,
       _createFolderUseCase = createFolderUseCase,
       _updateFolderUseCase = updateFolderUseCase,
       _deleteFolderUseCase = deleteFolderUseCase,
       _getChildFoldersUseCase = getChildFoldersUseCase,
       _moveFolderUseCase = moveFolderUseCase,
       _getPagesUseCase = getPagesUseCase;

  /// Load root folders for a workspace
  Future<void> loadRootFolders(String workspaceId) async {
    _rootFolders.value = const AsyncLoading();
    try {
      final roots = await _getRootFoldersUseCase(workspaceId);
      _rootFolders.value = AsyncData(roots);
    } catch (e, stack) {
      _rootFolders.value = AsyncError(e, stack);
    }
  }

  /// Get (or create) a signal for a folder's children
  Signal<AsyncState<List<FolderEntity>>> getChildrenSignal(String folderId) {
    if (_childrenCache.containsKey(folderId)) {
      return _childrenCache[folderId]!;
    }

    final s = signal<AsyncState<List<FolderEntity>>>(const AsyncLoading());
    _childrenCache[folderId] = s;

    // Initial load
    _loadChildren(folderId, s);

    return s;
  }

  Future<void> _loadChildren(
    String folderId,
    Signal<AsyncState<List<FolderEntity>>> s,
  ) async {
    s.value = const AsyncLoading();
    try {
      final children = await _getChildFoldersUseCase(folderId);
      s.value = AsyncData(children);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Get (or create) a signal for a folder's pages
  Signal<AsyncState<List<PageEntity>>> getPagesSignal(String folderId) {
    if (_pagesCache.containsKey(folderId)) {
      return _pagesCache[folderId]!;
    }

    final s = signal<AsyncState<List<PageEntity>>>(const AsyncLoading());
    _pagesCache[folderId] = s;

    // Initial load
    _loadPages(folderId, s);

    return s;
  }

  Future<void> _loadPages(
    String folderId,
    Signal<AsyncState<List<PageEntity>>> s,
  ) async {
    s.value = const AsyncLoading();
    try {
      final pages = await _getPagesUseCase(folderId);
      s.value = AsyncData(pages);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Toggle folder expansion
  void toggleFolder(String folderId) {
    final current = _expandedFolders.value;
    final next = Set<String>.from(current);

    if (next.contains(folderId)) {
      next.remove(folderId);
    } else {
      next.add(folderId);
      // Ensure children are loaded
      getChildrenSignal(folderId);
    }

    _expandedFolders.value = next;
  }

  /// Create a new folder
  Future<void> createFolder({
    required String name,
    required String workspaceId,
    String? parentId,
  }) async {
    final newFolder = FolderEntity(
      id: const Uuid().v4(),
      workspaceId: workspaceId,
      name: name,
      parentId: parentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _createFolderUseCase(newFolder);
    await refreshFolder(parentId, workspaceId);

    // Auto-expand parent
    if (parentId != null && !_expandedFolders.value.contains(parentId)) {
      toggleFolder(parentId);
    }
  }

  /// Delete a folder
  Future<void> deleteFolder(
    String folderId,
    String? parentId,
    String workspaceId,
  ) async {
    await _deleteFolderUseCase(folderId);
    _childrenCache.remove(folderId);
    await refreshFolder(parentId, workspaceId);
  }

  /// Update a folder's properties
  Future<void> updateFolder(FolderEntity folder, String workspaceId) async {
    await _updateFolderUseCase(folder);
    await refreshFolder(folder.parentId, workspaceId);
  }

  /// Move a folder
  Future<void> moveFolder(
    String folderId,
    String? oldParentId,
    String? newParentId,
    String workspaceId,
  ) async {
    await _moveFolderUseCase(folderId, newParentId);
    await refreshFolder(oldParentId, workspaceId);
    await refreshFolder(newParentId, workspaceId);
  }

  /// Refresh folder contents
  Future<void> refreshFolder(String? folderId, String workspaceId) async {
    if (folderId == null) {
      await loadRootFolders(workspaceId);
    } else {
      final s = _childrenCache[folderId];
      if (s != null) {
        await _loadChildren(folderId, s);
      }
      final sPages = _pagesCache[folderId];
      if (sPages != null) {
        await _loadPages(folderId, sPages);
      }
    }
  }

  /// Clear all cached state
  void clear() {
    _rootFolders.value = AsyncData([]);
    _expandedFolders.value = {};
    _childrenCache.clear();
    _pagesCache.clear();
  }
}
