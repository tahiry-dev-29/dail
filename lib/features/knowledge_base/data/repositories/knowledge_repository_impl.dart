import 'package:daily_os/features/knowledge_base/data/datasources/local/block_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/folder_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/page_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/property_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/tag_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/workspace_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:daily_os/features/knowledge_base/data/mappers/knowledge_mappers.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of Knowledge Base repository using Isar database
class KnowledgeRepositoryImpl implements IKnowledgeRepository {
  final WorkspaceLocalDatasource _workspaceDatasource;
  final FolderLocalDatasource _folderDatasource;
  final PageLocalDatasource _pageDatasource;
  final BlockLocalDatasource _blockDatasource;
  final PropertyLocalDatasource _propertyDatasource;
  final TagLocalDatasource _tagDatasource;
  final Uuid _uuid;

  KnowledgeRepositoryImpl({
    required WorkspaceLocalDatasource workspaceDatasource,
    required FolderLocalDatasource folderDatasource,
    required PageLocalDatasource pageDatasource,
    required BlockLocalDatasource blockDatasource,
    required PropertyLocalDatasource propertyDatasource,
    required TagLocalDatasource tagDatasource,
    Uuid? uuid,
  }) : _workspaceDatasource = workspaceDatasource,
       _folderDatasource = folderDatasource,
       _pageDatasource = pageDatasource,
       _blockDatasource = blockDatasource,
       _propertyDatasource = propertyDatasource,
       _tagDatasource = tagDatasource,
       _uuid = uuid ?? const Uuid();

  // ============ Workspace Operations ============

  @override
  Future<List<WorkspaceEntity>> getWorkspaces() async {
    final dtos = await _workspaceDatasource.getAll();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<WorkspaceEntity?> getWorkspace(String id) async {
    final dto = await _workspaceDatasource.getByUid(id);
    return dto?.toEntity();
  }

  @override
  Future<void> createWorkspace(WorkspaceEntity workspace) async {
    await _workspaceDatasource.save(workspace.toDTO());
  }

  @override
  Future<void> updateWorkspace(WorkspaceEntity workspace) async {
    await _workspaceDatasource.save(workspace.toDTO());
  }

  @override
  Future<void> deleteWorkspace(String id) async {
    await _workspaceDatasource.delete(id);
  }

  // ============ Folder Operations ============

  @override
  Future<List<FolderEntity>> getRootFolders(String workspaceId) async {
    final dtos = await _folderDatasource.getRootFolders(workspaceId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<FolderEntity>> getChildFolders(String parentId) async {
    final dtos = await _folderDatasource.getChildren(parentId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<FolderEntity?> getFolder(String id) async {
    final dto = await _folderDatasource.getByUid(id);
    return dto?.toEntity();
  }

  @override
  Future<void> createFolder(FolderEntity folder) async {
    final dto = FolderDTO.create(
      uid: folder.id.isEmpty ? _uuid.v4() : folder.id,
      parentUid: folder.parentId,
      workspaceUid: folder.workspaceId,
      name: folder.name,
      iconEmoji: folder.iconEmoji,
      coverColor: folder.coverColor,
      sortOrder: folder.sortOrder,
    );
    await _folderDatasource.save(dto);
  }

  @override
  Future<void> updateFolder(FolderEntity folder) async {
    await _folderDatasource.save(folder.toDTO());
  }

  @override
  Future<void> moveFolder(String folderId, String? newParentId) async {
    await _folderDatasource.move(folderId, newParentId);
  }

  @override
  Future<void> deleteFolder(String id) async {
    await _folderDatasource.softDelete(id);
  }

  @override
  Future<void> permanentlyDeleteFolder(String id) async {
    await _folderDatasource.permanentlyDelete(id);
  }

  // ============ Page Operations ============

  @override
  Future<List<PageEntity>> getPages(String folderId) async {
    final dtos = await _pageDatasource.getByFolder(folderId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PageEntity>> getWorkspacePages(String workspaceId) async {
    final dtos = await _pageDatasource.getByWorkspace(workspaceId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<PageEntity?> getPage(String id) async {
    final pageDto = await _pageDatasource.getByUid(id);
    if (pageDto == null) return null;

    // Load blocks for this page
    final blockDtos = await _blockDatasource.getByPage(id);
    final blocks = blockDtos.map((b) => b.toEntity()).toList();

    // Load properties for this page
    final propertyDtos = await _propertyDatasource.getByPage(id);
    final properties = propertyDtos.map((p) => p.toEntity()).toList();

    return pageDto.toEntity(blocks: blocks, properties: properties);
  }

  @override
  Future<void> createPage(PageEntity page) async {
    final dto = PageDTO.create(
      uid: page.id.isEmpty ? _uuid.v4() : page.id,
      folderUid: page.folderId,
      title: page.title,
      iconEmoji: page.iconEmoji,
      coverImageUrl: page.coverImageUrl,
    );
    await _pageDatasource.save(dto);
  }

  @override
  Future<void> updatePage(PageEntity page) async {
    await _pageDatasource.save(page.toDTO());
  }

  @override
  Future<void> togglePageFavorite(String pageId) async {
    await _pageDatasource.toggleFavorite(pageId);
  }

  @override
  Future<void> movePage(String pageId, String newFolderId) async {
    await _pageDatasource.move(pageId, newFolderId);
  }

  @override
  Future<void> deletePage(String id) async {
    await _pageDatasource.softDelete(id);
  }

  @override
  Future<void> permanentlyDeletePage(String id) async {
    await _blockDatasource.deleteAllForPage(id);
    await _propertyDatasource.deleteAllForPage(id);
    await _pageDatasource.permanentlyDelete(id);
  }

  @override
  Future<List<PageEntity>> searchPages(String query) async {
    final dtos = await _pageDatasource.search(query);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PageEntity>> getRecentPages({int limit = 10}) async {
    final dtos = await _pageDatasource.getRecent(limit);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> reorderPages(String folderId, List<String> pageIds) async {
    await _pageDatasource.reorder(folderId, pageIds);
  }

  // ============ Block Operations ============

  @override
  Future<List<BlockEntity>> getBlocks(String pageId) async {
    final dtos = await _blockDatasource.getByPage(pageId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addBlock(BlockEntity block) async {
    await _blockDatasource.save(block.toDTO());
  }

  @override
  Future<void> updateBlock(BlockEntity block) async {
    await _blockDatasource.save(block.toDTO());
  }

  @override
  Future<void> deleteBlock(String id) async {
    await _blockDatasource.delete(id);
  }

  @override
  Future<void> reorderBlocks(String pageId, List<String> blockIds) async {
    await _blockDatasource.reorder(pageId, blockIds);
  }

  // ============ Property Operations ============

  @override
  Future<List<PropertyEntity>> getProperties(String pageId) async {
    final dtos = await _propertyDatasource.getByPage(pageId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addProperty(PropertyEntity property) async {
    await _propertyDatasource.save(property.toDTO());
  }

  @override
  Future<void> updateProperty(PropertyEntity property) async {
    await _propertyDatasource.save(property.toDTO());
  }

  @override
  Future<void> deleteProperty(String id) async {
    await _propertyDatasource.delete(id);
  }

  // ============ Tag Operations ============

  @override
  Future<List<TagEntity>> getTags({String? workspaceId}) async {
    final dtos = workspaceId != null
        ? await _tagDatasource.getByWorkspace(workspaceId)
        : await _tagDatasource.getAll();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TagEntity?> getTag(String id) async {
    final dto = await _tagDatasource.getByUid(id);
    return dto?.toEntity();
  }

  @override
  Future<void> createTag(TagEntity tag) async {
    await _tagDatasource.save(tag.toDTO());
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    await _tagDatasource.save(tag.toDTO());
  }

  @override
  Future<void> deleteTag(String id) async {
    await _tagDatasource.delete(id);
  }

  // ============ Trash Operations ============

  @override
  Future<List<FolderEntity>> getDeletedFolders() async {
    final dtos = await _folderDatasource.getDeleted();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<PageEntity>> getDeletedPages() async {
    final dtos = await _pageDatasource.getDeleted();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> restoreFolder(String id) async {
    await _folderDatasource.restore(id);
  }

  @override
  Future<void> restorePage(String id) async {
    await _pageDatasource.restore(id);
  }

  @override
  Future<void> emptyTrash() async {
    final deletedFolders = await _folderDatasource.getDeleted();
    for (final folder in deletedFolders) {
      await _folderDatasource.permanentlyDelete(folder.uid);
    }

    final deletedPages = await _pageDatasource.getDeleted();
    for (final page in deletedPages) {
      await _blockDatasource.deleteAllForPage(page.uid);
      await _pageDatasource.permanentlyDelete(page.uid);
    }
  }
}
