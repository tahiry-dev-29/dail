import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Folder CRUD operations with recursive support
class FolderLocalDatasource {
  final Isar isar;

  FolderLocalDatasource(this.isar);

  /// Get root folders for a workspace (parentUid is null)
  Future<List<FolderDTO>> getRootFolders(String workspaceUid) async {
    return isar.folderDTOs
        .filter()
        .workspaceUidEqualTo(workspaceUid)
        .parentUidIsNull()
        .isDeletedEqualTo(false)
        .sortBySortOrder()
        .findAll();
  }

  /// Get child folders of a parent folder (lazy loading)
  Future<List<FolderDTO>> getChildren(String parentUid) async {
    return isar.folderDTOs
        .filter()
        .parentUidEqualTo(parentUid)
        .isDeletedEqualTo(false)
        .sortBySortOrder()
        .findAll();
  }

  /// Get folder by UID
  Future<FolderDTO?> getByUid(String uid) async {
    return isar.folderDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Get all folders for a workspace
  Future<List<FolderDTO>> getAllForWorkspace(String workspaceUid) async {
    return isar.folderDTOs
        .filter()
        .workspaceUidEqualTo(workspaceUid)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Create or update a folder
  Future<void> save(FolderDTO folder) async {
    await isar.writeTxn(() async {
      // Check for existing to prevent unique constraint violation
      final existing = await isar.folderDTOs
          .filter()
          .uidEqualTo(folder.uid)
          .findFirst();
      if (existing != null) {
        folder.id = existing.id;
      }
      folder.updatedAt = DateTime.now();
      await isar.folderDTOs.put(folder);
    });
  }

  /// Soft delete (move to trash)
  Future<void> softDelete(String uid) async {
    final folder = await getByUid(uid);
    if (folder != null) {
      folder.isDeleted = true;
      folder.updatedAt = DateTime.now();
      await save(folder);
    }
  }

  /// Restore from trash
  Future<void> restore(String uid) async {
    final folder = await getByUid(uid);
    if (folder != null) {
      folder.isDeleted = false;
      folder.updatedAt = DateTime.now();
      await save(folder);
    }
  }

  /// Get deleted folders (trash)
  Future<List<FolderDTO>> getDeleted() async {
    return isar.folderDTOs.filter().isDeletedEqualTo(true).findAll();
  }

  /// Permanently delete a folder
  Future<void> permanentlyDelete(String uid) async {
    await isar.writeTxn(() async {
      await isar.folderDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Move folder to new parent
  Future<void> move(String uid, String? newParentUid) async {
    final folder = await getByUid(uid);
    if (folder != null) {
      folder.parentUid = newParentUid;
      folder.updatedAt = DateTime.now();
      await save(folder);
    }
  }
}
