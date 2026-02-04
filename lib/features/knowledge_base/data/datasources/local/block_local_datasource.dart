import 'package:daily_os/features/knowledge_base/data/dtos/block_dto.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Block CRUD operations
class BlockLocalDatasource {
  final Isar isar;

  BlockLocalDatasource(this.isar);

  /// Get blocks for a page (ordered by sortOrder)
  Future<List<BlockDTO>> getByPage(String pageUid) async {
    return isar.blockDTOs
        .filter()
        .pageUidEqualTo(pageUid)
        .sortBySortOrder()
        .findAll();
  }

  /// Get block by UID
  Future<BlockDTO?> getByUid(String uid) async {
    return isar.blockDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a block
  Future<void> save(BlockDTO block) async {
    await isar.writeTxn(() async {
      final existing = await isar.blockDTOs
          .filter()
          .uidEqualTo(block.uid)
          .findFirst();
      if (existing != null) {
        block.id = existing.id;
      }
      await isar.blockDTOs.put(block);
    });
  }

  /// Save multiple blocks (for reordering)
  Future<void> saveAll(List<BlockDTO> blocks) async {
    await isar.writeTxn(() async {
      for (final block in blocks) {
        final existing = await isar.blockDTOs
            .filter()
            .uidEqualTo(block.uid)
            .findFirst();
        if (existing != null) {
          block.id = existing.id;
        }
      }
      await isar.blockDTOs.putAll(blocks);
    });
  }

  /// Delete a block
  Future<void> delete(String uid) async {
    await isar.writeTxn(() async {
      await isar.blockDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Delete all blocks for a page
  Future<void> deleteAllForPage(String pageUid) async {
    await isar.writeTxn(() async {
      await isar.blockDTOs.filter().pageUidEqualTo(pageUid).deleteAll();
    });
  }

  /// Reorder blocks
  Future<void> reorder(String pageUid, List<String> blockUids) async {
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
