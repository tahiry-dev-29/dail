import 'package:daily_os/features/knowledge_base/data/dtos/property_dto.dart';
import 'package:daily_os/features/knowledge_base/services/isar_service.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Property CRUD operations
class PropertyLocalDatasource {
  /// Get properties for a page
  Future<List<PropertyDTO>> getByPage(String pageUid) async {
    final isar = await IsarService.instance;
    return isar.propertyDTOs.filter().pageUidEqualTo(pageUid).findAll();
  }

  /// Get property by UID
  Future<PropertyDTO?> getByUid(String uid) async {
    final isar = await IsarService.instance;
    return isar.propertyDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a property
  Future<void> save(PropertyDTO property) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      final existing = await isar.propertyDTOs
          .filter()
          .uidEqualTo(property.uid)
          .findFirst();
      if (existing != null) {
        property.id = existing.id;
      }
      await isar.propertyDTOs.put(property);
    });
  }

  /// Delete a property
  Future<void> delete(String uid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.propertyDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Delete all properties for a page
  Future<void> deleteAllForPage(String pageUid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.propertyDTOs.filter().pageUidEqualTo(pageUid).deleteAll();
    });
  }
}
