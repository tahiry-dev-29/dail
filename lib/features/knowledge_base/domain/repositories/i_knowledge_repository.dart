import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';

/// Repository interface for Knowledge Base feature
/// Defines all CRUD operations for workspaces, folders, pages, blocks, and tags
abstract class IKnowledgeRepository {
  // ============ Workspace Operations ============

  /// Get all workspaces
  Future<List<WorkspaceEntity>> getWorkspaces();

  /// Get workspace by ID
  Future<WorkspaceEntity?> getWorkspace(String id);

  /// Create a new workspace
  Future<void> createWorkspace(WorkspaceEntity workspace);

  /// Update workspace
  Future<void> updateWorkspace(WorkspaceEntity workspace);

  /// Delete workspace
  Future<void> deleteWorkspace(String id);

  // ============ Folder Operations ============

  /// Get root folders for a workspace
  Future<List<FolderEntity>> getRootFolders(String workspaceId);

  /// Get child folders of a parent folder (lazy loading)
  Future<List<FolderEntity>> getChildFolders(String parentId);

  /// Get folder by ID
  Future<FolderEntity?> getFolder(String id);

  /// Create a new folder
  Future<void> createFolder(FolderEntity folder);

  /// Update folder
  Future<void> updateFolder(FolderEntity folder);

  /// Move folder to new parent
  Future<void> moveFolder(String folderId, String? newParentId);

  /// Soft delete folder (move to trash)
  Future<void> deleteFolder(String id);

  /// Permanently delete folder
  Future<void> permanentlyDeleteFolder(String id);

  // ============ Page Operations ============

  /// Get pages in a folder
  Future<List<PageEntity>> getPages(String folderId);

  /// Get page by ID with all blocks and properties
  Future<PageEntity?> getPage(String id);

  /// Create a new page
  Future<void> createPage(PageEntity page);

  /// Update page (metadata only, not blocks)
  Future<void> updatePage(PageEntity page);

  /// Move page to new folder
  Future<void> movePage(String pageId, String newFolderId);

  /// Soft delete page (move to trash)
  Future<void> deletePage(String id);

  /// Permanently delete page
  Future<void> permanentlyDeletePage(String id);

  /// Search pages by title or content
  Future<List<PageEntity>> searchPages(String query);

  /// Get recently updated pages
  Future<List<PageEntity>> getRecentPages({int limit = 10});

  // ============ Block Operations ============

  /// Get all blocks for a page
  Future<List<BlockEntity>> getBlocks(String pageId);

  /// Add a new block to page
  Future<void> addBlock(BlockEntity block);

  /// Update block content
  Future<void> updateBlock(BlockEntity block);

  /// Delete block
  Future<void> deleteBlock(String id);

  /// Reorder blocks
  Future<void> reorderBlocks(String pageId, List<String> blockIds);

  // ============ Property Operations ============

  /// Get properties for a page
  Future<List<PropertyEntity>> getProperties(String pageId);

  /// Add property to page
  Future<void> addProperty(PropertyEntity property);

  /// Update property
  Future<void> updateProperty(PropertyEntity property);

  /// Delete property
  Future<void> deleteProperty(String id);

  // ============ Tag Operations ============

  /// Get all tags (optionally filtered by workspace)
  Future<List<TagEntity>> getTags({String? workspaceId});

  /// Get tag by ID
  Future<TagEntity?> getTag(String id);

  /// Create a new tag
  Future<void> createTag(TagEntity tag);

  /// Update tag
  Future<void> updateTag(TagEntity tag);

  /// Delete tag
  Future<void> deleteTag(String id);

  // ============ Trash Operations ============

  /// Get all deleted folders
  Future<List<FolderEntity>> getDeletedFolders();

  /// Get all deleted pages
  Future<List<PageEntity>> getDeletedPages();

  /// Restore folder from trash
  Future<void> restoreFolder(String id);

  /// Restore page from trash
  Future<void> restorePage(String id);

  /// Empty trash (permanently delete all)
  Future<void> emptyTrash();
}
