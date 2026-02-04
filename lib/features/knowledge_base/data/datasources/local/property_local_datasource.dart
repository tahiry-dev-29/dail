import 'dart:convert';

import 'package:daily_os/features/knowledge_base/data/dtos/property_dto.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Property CRUD operations
class PropertyLocalDatasource {
  final Isar isar;

  PropertyLocalDatasource(this.isar);

  /// Get all unique tags used across all pages
  Future<List<String>> getAllUniqueTags() async {
    final properties = await isar.propertyDTOs
        .filter()
        .typeEqualTo(PropertyTypeDTO.tags)
        .findAll();

    final allTags = <String>{};
    for (final prop in properties) {
      try {
        final decoded = json.decode(prop.valueJson);
        if (decoded is List) {
          allTags.addAll(decoded.cast<String>());
        }
      } catch (_) {}
    }
    return allTags.toList()..sort();
  }

  /// Get properties for a page
  Future<List<PropertyDTO>> getByPage(String pageUid) async {
    return isar.propertyDTOs.filter().pageUidEqualTo(pageUid).findAll();
  }

  /// Get property by UID
  Future<PropertyDTO?> getByUid(String uid) async {
    return isar.propertyDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a property
  Future<void> save(PropertyDTO property) async {
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
    await isar.writeTxn(() async {
      await isar.propertyDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Delete all properties for a page
  Future<void> deleteAllForPage(String pageUid) async {
    await isar.writeTxn(() async {
      await isar.propertyDTOs.filter().pageUidEqualTo(pageUid).deleteAll();
    });
  }
}
