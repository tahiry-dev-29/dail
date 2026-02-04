import 'package:daily_os/features/knowledge_base/data/dtos/tag_dto.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Tag CRUD operations
class TagLocalDatasource {
  final Isar isar;

  TagLocalDatasource(this.isar);

  /// Get all tags
  Future<List<TagDTO>> getAll() async {
    return isar.tagDTOs.where().findAll();
  }

  /// Get tags by workspace
  Future<List<TagDTO>> getByWorkspace(String workspaceId) async {
    return isar.tagDTOs.filter().workspaceIdEqualTo(workspaceId).findAll();
  }

  /// Get tag by UID
  Future<TagDTO?> getByUid(String uid) async {
    return isar.tagDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a tag
  Future<void> save(TagDTO tag) async {
    await isar.writeTxn(() async {
      final existing = await isar.tagDTOs
          .filter()
          .uidEqualTo(tag.uid)
          .findFirst();
      if (existing != null) {
        tag.id = existing.id;
      }
      await isar.tagDTOs.put(tag);
    });
  }

  /// Delete a tag by UID
  Future<void> delete(String uid) async {
    await isar.writeTxn(() async {
      await isar.tagDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }
}
