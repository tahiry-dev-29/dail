import 'package:daily_os/features/knowledge_base/data/dtos/block_dto.dart';
import 'package:daily_os/features/knowledge_base/services/isar_service.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Block CRUD operations
class BlockLocalDatasource {
  /// Get blocks for a page (ordered by sortOrder)
  Future<List<BlockDTO>> getByPage(String pageUid) async {
    final isar = await IsarService.instance;
    return isar.blockDTOs
        .filter()
        .pageUidEqualTo(pageUid)
        .sortBySortOrder()
        .findAll();
  }

  /// Get block by UID
  Future<BlockDTO?> getByUid(String uid) async {
    final isar = await IsarService.instance;
    return isar.blockDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a block
  Future<void> save(BlockDTO block) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.blockDTOs.put(block);
    });
  }

  /// Save multiple blocks (for reordering)
  Future<void> saveAll(List<BlockDTO> blocks) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.blockDTOs.putAll(blocks);
    });
  }

  /// Delete a block
  Future<void> delete(String uid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.blockDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Delete all blocks for a page
  Future<void> deleteAllForPage(String pageUid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.blockDTOs.filter().pageUidEqualTo(pageUid).deleteAll();
    });
  }

  /// Reorder blocks
  Future<void> reorder(String pageUid, List<String> blockUids) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      for (var i = 0; i < blockUids.length; i++) {
        final block = await isar.blockDTOs
            .filter()
            .uidEqualTo(blockUids[i])
            .findFirst();
        if (block != null) {
          block.sortOrder = i;
          await isar.blockDTOs.put(block);
        }
      }
    });
  }
}
