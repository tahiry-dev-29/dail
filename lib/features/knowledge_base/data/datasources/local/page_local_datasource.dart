import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:daily_os/features/knowledge_base/services/isar_service.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Page CRUD operations
class PageLocalDatasource {
  /// Get pages in a folder
  Future<List<PageDTO>> getByFolder(String folderUid) async {
    final isar = await IsarService.instance;
    return isar.pageDTOs
        .filter()
        .folderUidEqualTo(folderUid)
        .isDeletedEqualTo(false)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  /// Get page by UID
  Future<PageDTO?> getByUid(String uid) async {
    final isar = await IsarService.instance;
    return isar.pageDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a page
  Future<void> save(PageDTO page) async {
    final isar = await IsarService.instance;
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
    final isar = await IsarService.instance;
    return isar.pageDTOs.filter().isDeletedEqualTo(true).findAll();
  }

  /// Permanently delete a page
  Future<void> permanentlyDelete(String uid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.pageDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Search pages by title
  Future<List<PageDTO>> search(String query) async {
    final isar = await IsarService.instance;
    return isar.pageDTOs
        .filter()
        .titleContains(query, caseSensitive: false)
        .isDeletedEqualTo(false)
        .findAll();
  }
}
