import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/logic/workspace_state.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// Controller for Folder Tree operations
class FolderTreeController {
  static void Function()? _outputDisposable;

  /// Initialize listeners (call this when app starts or module loads)
  static void init() {
    _outputDisposable?.call();
    _outputDisposable = effect(() {
      final workspace = activeWorkspaceSignal.value;
      if (workspace != null) {
        loadRootFolders(workspace.id);
      } else {
        rootFoldersSignal.value = AsyncData([]);
      }
    });
  }

  /// Load root folders for a specific workspace
  static Future<void> loadRootFolders(String workspaceId) async {
    rootFoldersSignal.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final roots = await repo.getRootFolders(workspaceId);
      rootFoldersSignal.value = AsyncData(roots);
    } catch (e, stack) {
      rootFoldersSignal.value = AsyncError(e, stack);
    }
  }

  /// Get (or create) a signal for a folder's children
  static Signal<AsyncState<List<FolderEntity>>> getChildrenSignal(
    String folderId,
  ) {
    if (folderChildrenCache.containsKey(folderId)) {
      return folderChildrenCache[folderId]!;
    }

    final s = signal<AsyncState<List<FolderEntity>>>(AsyncLoading());
    folderChildrenCache[folderId] = s;

    // Initial load
    _loadChildren(folderId, s);

    return s;
  }

  static Future<void> _loadChildren(
    String folderId,
    Signal<AsyncState<List<FolderEntity>>> s,
  ) async {
    s.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final children = await repo.getChildFolders(folderId);
      s.value = AsyncData(children);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Get (or create) a signal for a folder's pages
  static Signal<AsyncState<List<PageEntity>>> getPagesSignal(String folderId) {
    if (folderPagesCache.containsKey(folderId)) {
      return folderPagesCache[folderId]!;
    }

    final s = signal<AsyncState<List<PageEntity>>>(AsyncLoading());
    folderPagesCache[folderId] = s;

    // Initial load
    _loadPages(folderId, s);

    return s;
  }

  static Future<void> _loadPages(
    String folderId,
    Signal<AsyncState<List<PageEntity>>> s,
  ) async {
    s.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final pages = await repo.getPages(folderId);
      s.value = AsyncData(pages);
    } catch (e, stack) {
      s.value = AsyncError(e, stack);
    }
  }

  /// Refresh a specific folder's children (or roots if parentId is null)
  static Future<void> refreshFolder(String? folderId) async {
    if (folderId == null) {
      final workspace = activeWorkspaceSignal.value;
      if (workspace != null) {
        await loadRootFolders(workspace.id);
      }
    } else {
      final s = folderChildrenCache[folderId];
      if (s != null) {
        await _loadChildren(folderId, s);
      }
      final sPages = folderPagesCache[folderId];
      if (sPages != null) {
        await _loadPages(folderId, sPages);
      }
    }
  }

  /// Toggle folder expansion
  static void toggleFolder(String folderId) {
    final current = expandedFoldersSignal.value;
    final next = Set<String>.from(current);
    if (next.contains(folderId)) {
      next.remove(folderId);
    } else {
      next.add(folderId);
      // Ensure children are loaded
      getChildrenSignal(folderId);
    }
    expandedFoldersSignal.value = next;
  }

  /// Create a new folder
  static Future<void> createFolder({
    required String name,
    required String workspaceId,
    String? parentId,
  }) async {
    try {
      final repo = knowledgeRepository.value;
      final newFolder = FolderEntity(
        id: const Uuid().v4(),
        workspaceId: workspaceId,
        name: name,
        parentId: parentId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.createFolder(newFolder);
      await refreshFolder(parentId);

      // Auto-expand parent if not root
      if (parentId != null) {
        final current = expandedFoldersSignal.value;
        if (!current.contains(parentId)) {
          toggleFolder(parentId);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a folder
  static Future<void> deleteFolder(String folderId, String? parentId) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.deleteFolder(folderId);

      // Remove from cache if exists
      folderChildrenCache.remove(folderId);

      // Refresh parent
      await refreshFolder(parentId);
    } catch (e) {
      rethrow;
    }
  }

  /// Move a folder
  static Future<void> moveFolder(
    String folderId,
    String? oldParentId,
    String? newParentId,
  ) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.moveFolder(folderId, newParentId);

      await refreshFolder(oldParentId);
      await refreshFolder(newParentId);
    } catch (e) {
      rethrow;
    }
  }
}
