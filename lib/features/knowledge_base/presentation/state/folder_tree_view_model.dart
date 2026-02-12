import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/create_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/delete_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_child_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_root_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/move_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/update_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/reorder_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/get_tasks_by_folder_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for Folder Tree operations
class FolderTreeViewModel {
  // Dependencies
  final GetRootFoldersUseCase _getRootFoldersUseCase;
  final CreateFolderUseCase _createFolderUseCase;
  final UpdateFolderUseCase _updateFolderUseCase;
  final DeleteFolderUseCase _deleteFolderUseCase;
  final GetChildFoldersUseCase _getChildFoldersUseCase;
  final MoveFolderUseCase _moveFolderUseCase;
  final GetPagesUseCase _getPagesUseCase;
  final ReorderPagesUseCase _reorderPagesUseCase;
  final GetTasksByFolderUseCase _getTasksByFolderUseCase;
  final WorkspaceViewModel _workspaceVM;

  // State
  final Signal<AsyncState<List<FolderEntity>>> _rootFolders = signal(
    const AsyncData([]),
  );
  final Signal<Set<String>> _expandedFolders = signal({});

  // Cache for lazy-loaded contents
  final Map<String, Signal<AsyncState<List<FolderEntity>>>> _childrenCache = {};
  final Map<String, Signal<AsyncState<List<PageEntity>>>> _pagesCache = {};
  final Map<String, Signal<AsyncState<List<TaskEntity>>>> _tasksCache = {};

  // Track last loaded workspace to prevent redundant loads
  String? _lastLoadedWorkspaceId;

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
    required ReorderPagesUseCase reorderPagesUseCase,
    required GetTasksByFolderUseCase getTasksByFolderUseCase,
    required WorkspaceViewModel workspaceVM,
  }) : _getRootFoldersUseCase = getRootFoldersUseCase,
       _createFolderUseCase = createFolderUseCase,
       _updateFolderUseCase = updateFolderUseCase,
       _deleteFolderUseCase = deleteFolderUseCase,
       _getChildFoldersUseCase = getChildFoldersUseCase,
       _moveFolderUseCase = moveFolderUseCase,
       _getPagesUseCase = getPagesUseCase,
       _reorderPagesUseCase = reorderPagesUseCase,
       _getTasksByFolderUseCase = getTasksByFolderUseCase,
       _workspaceVM = workspaceVM {
    // Automatically load root folders when active workspace changes
    effect(() {
      final workspace = _workspaceVM.activeWorkspace.value;
      final workspaceId = workspace?.id;

      // Only load if workspace ID actually changed
      if (workspaceId != _lastLoadedWorkspaceId) {
        _lastLoadedWorkspaceId = workspaceId;

        if (workspaceId != null) {
          // Use microtask to avoid synchronous state updates during build
          Future.microtask(() => loadRootFolders(workspaceId));
        } else {
          _rootFolders.value = const AsyncData([]);
        }
      }
    });
  }

  /// Get folder by ID synchronously (from caches or root)
  FolderEntity? getFolderSync(String folderId) {
    // Check root folders
    final roots = _rootFolders.value;
    if (roots is AsyncData<List<FolderEntity>>) {
      final found = _findInList(roots.value, folderId);
      if (found != null) return found;
    }

    // Check children caches
    for (final signal in _childrenCache.values) {
      final state = signal.value;
      if (state is AsyncData<List<FolderEntity>>) {
        final found = _findInList(state.value, folderId);
        if (found != null) return found;
      }
    }

    return null;
  }

  FolderEntity? _findInList(List<FolderEntity> list, String id) {
    for (final f in list) {
      if (f.id == id) return f;
    }
    return null;
  }

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
    return _childrenCache.putIfAbsent(
      folderId,
      () => signal<AsyncState<List<FolderEntity>>>(const AsyncData([])),
    );
  }

  Future<void> _loadChildren(
    String folderId,
    Signal<AsyncState<List<FolderEntity>>> s,
  ) async {
    // Only load if not already loading or loaded non-empty
    if (s.value is AsyncLoading) return;
    if (s.value is AsyncData && (s.value.value?.isNotEmpty ?? false)) return;

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
    return _pagesCache.putIfAbsent(
      folderId,
      () => signal<AsyncState<List<PageEntity>>>(const AsyncData([])),
    );
  }

  Future<void> _loadPages(
    String folderId,
    Signal<AsyncState<List<PageEntity>>> s,
  ) async {
    // Only load if not already loading or loaded non-empty
    if (s.value is AsyncLoading) return;
    if (s.value is AsyncData && (s.value.value?.isNotEmpty ?? false)) return;

    s.value = const AsyncLoading();
    try {
      final pages = await _getPagesUseCase(folderId);
      s.value = AsyncData(pages);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Get (or create) a signal for a folder's tasks
  Signal<AsyncState<List<TaskEntity>>> getTasksSignal(String folderId) {
    return _tasksCache.putIfAbsent(
      folderId,
      () => signal<AsyncState<List<TaskEntity>>>(const AsyncData([])),
    );
  }

  Future<void> _loadTasks(
    String folderId,
    Signal<AsyncState<List<TaskEntity>>> s,
  ) async {
    // Only load if not already loading or loaded non-empty
    if (s.value is AsyncLoading) return;
    if (s.value is AsyncData && (s.value.value?.isNotEmpty ?? false)) return;

    s.value = const AsyncLoading();
    try {
      final tasks = await _getTasksByFolderUseCase(folderId);
      s.value = AsyncData(tasks);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Ensure all contents of a folder are loaded
  Future<void> ensureLoaded(String folderId) async {
    await Future.wait([
      _loadChildren(folderId, getChildrenSignal(folderId)),
      _loadPages(folderId, getPagesSignal(folderId)),
      _loadTasks(folderId, getTasksSignal(folderId)),
    ]);
  }

  /// Toggle folder expansion
  void toggleFolder(String folderId) {
    final current = _expandedFolders.value;
    final next = Set<String>.from(current);

    if (next.contains(folderId)) {
      next.remove(folderId);
    } else {
      next.add(folderId);
      // Trigger lazy load via microtask to avoid synchronous state updates
      Future.microtask(() => ensureLoaded(folderId));
    }

    _expandedFolders.value = next;
  }

  /// Refresh folder contents
  Future<void> refreshFolder(String? folderId, String workspaceId) async {
    if (folderId == null) {
      await loadRootFolders(workspaceId);
    } else {
      final s = _childrenCache[folderId];
      if (s != null) await _loadChildren(folderId, s);

      final sPages = _pagesCache[folderId];
      if (sPages != null) await _loadPages(folderId, sPages);

      final sTasks = _tasksCache[folderId];
      if (sTasks != null) await _loadTasks(folderId, sTasks);
    }
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
    _pagesCache.remove(folderId);
    _tasksCache.remove(folderId);
    await refreshFolder(parentId, workspaceId);
  }

  // Simplified rest of crud for brevity, but keep signatures
  Future<void> updateFolder(FolderEntity folder, String workspaceId) async {
    await _updateFolderUseCase(folder);
    await refreshFolder(folder.parentId, workspaceId);
  }

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

  /// Reorder pages in a folder
  Future<void> reorderPages(
    String folderId,
    List<PageEntity> reorderedPages,
  ) async {
    final pageIds = reorderedPages.map((p) => p.id).toList();

    // 1. Optimistic Update: Push data to signal immediately to prevent jump
    final s = _pagesCache[folderId];
    if (s != null) {
      s.value = AsyncData(reorderedPages);
    }

    try {
      await _reorderPagesUseCase(folderId, pageIds);
    } catch (e) {
      // Revert cache on error
      if (s != null) await _loadPages(folderId, s);
      rethrow;
    }
  }

  void clear() {
    _rootFolders.value = const AsyncData([]);
    _expandedFolders.value = {};
    _childrenCache.clear();
    _pagesCache.clear();
    _tasksCache.clear();
  }
}
