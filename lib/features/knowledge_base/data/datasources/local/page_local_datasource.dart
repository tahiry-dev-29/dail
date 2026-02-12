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
