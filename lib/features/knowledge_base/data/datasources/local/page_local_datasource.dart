import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Page CRUD operations
class PageLocalDatasource {
  final Isar isar;

  PageLocalDatasource(this.isar);

  /// Get pages in a folder
  Future<List<PageDTO>> getByFolder(String folderUid) async {
    return isar.pageDTOs
        .filter()
        .folderUidEqualTo(folderUid)
        .isDeletedEqualTo(false)
        .sortBySortOrder()
        .findAll();
  }

  /// Get all pages in a workspace
  Future<List<PageDTO>> getByWorkspace(String workspaceUid) async {
    // 1. Get all folders in the workspace
    final folders = await isar.folderDTOs
        .filter()
        .workspaceUidEqualTo(workspaceUid)
        .isDeletedEqualTo(false)
        .findAll();
    final folderIds = folders.map((f) => f.uid).toList();

    // 2. Get all pages belonging to those folders
    if (folderIds.isEmpty) return [];

    // We fetch all pages and filter, since Isar doesn't easily support WHERE IN list for strings without writing a loop
    final allPages = await isar.pageDTOs
        .filter()
        .isDeletedEqualTo(false)
        .findAll();
    return allPages.where((p) => folderIds.contains(p.folderUid)).toList();
  }

  /// Reorder pages in a folder
  Future<void> reorder(String folderUid, List<String> pageUids) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < pageUids.length; i++) {
        final page = await isar.pageDTOs
            .filter()
            .uidEqualTo(pageUids[i])
            .findFirst();
        if (page != null) {
          page.sortOrder = i;
          await isar.pageDTOs.put(page);
        }
      }
    });
  }

  /// Get page by UID
  Future<PageDTO?> getByUid(String uid) async {
    return isar.pageDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a page
  Future<void> save(PageDTO page) async {
    await isar.writeTxn(() async {
      final existing = await isar.pageDTOs
          .filter()
          .uidEqualTo(page.uid)
          .findFirst();
      if (existing != null) {
        page.id = existing.id;
      }
      page.updatedAt = DateTime.now();
      await isar.pageDTOs.put(page);
    });
  }

  /// Toggle page favorite
  Future<void> toggleFavorite(String uid) async {
    final page = await getByUid(uid);
    if (page != null) {
      page.isFavorite = !page.isFavorite;
      page.updatedAt = DateTime.now();
      await save(page);
    }
  }

  /// Move page to new folder
  Future<void> move(String uid, String newFolderUid) async {
    final page = await getByUid(uid);
    if (page != null) {
      page.folderUid = newFolderUid;
      page.updatedAt = DateTime.now();
      await save(page);
    }
  }

  /// Soft delete (move to trash)
  Future<void> softDelete(String uid) async {
    final page = await getByUid(uid);
    if (page != null) {
      page.isDeleted = true;
      page.updatedAt = DateTime.now();
      await save(page);
    }
  }

  /// Restore from trash
  Future<void> restore(String uid) async {
    final page = await getByUid(uid);
    if (page != null) {
      page.isDeleted = false;
      page.updatedAt = DateTime.now();
      await save(page);
    }
  }

  /// Get deleted pages (trash)
  Future<List<PageDTO>> getDeleted() async {
    return isar.pageDTOs.filter().isDeletedEqualTo(true).findAll();
  }

  /// Permanently delete a page
  Future<void> permanentlyDelete(String uid) async {
    await isar.writeTxn(() async {
      await isar.pageDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Search pages by title
  Future<List<PageDTO>> search(String query) async {
    return isar.pageDTOs
        .filter()
        .titleContains(query, caseSensitive: false)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Get recently updated pages across all folders
  Future<List<PageDTO>> getRecent(int limit) async {
    return isar.pageDTOs
        .filter()
        .isDeletedEqualTo(false)
        .sortByUpdatedAtDesc()
        .limit(limit)
        .findAll();
  }
}
