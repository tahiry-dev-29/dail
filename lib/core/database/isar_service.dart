import 'package:daily_os/features/knowledge_base/data/dtos/block_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/property_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/tag_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/workspace_dto.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Isar database service for Knowledge Base
/// Handles database initialization and provides access to collections
class IsarService {
  static Isar? _isar;

  /// Get the Isar instance (singleton)
  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;
    _isar = await _openDatabase();
    return _isar!;
  }

  /// Open the Isar database
  static Future<Isar> _openDatabase() async {
    final dir = await getApplicationDocumentsDirectory();

    return Isar.open(
      [
        WorkspaceDTOSchema,
        FolderDTOSchema,
        PageDTOSchema,
        BlockDTOSchema,
        PropertyDTOSchema,
        TaskDTOSchema,
        TagDTOSchema,
      ],
      directory: dir.path,
      name: 'knowledge_base',
    );
  }

  /// Close the database (for testing/cleanup)
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  /// Clear all data (for testing)
  static Future<void> clearAll() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
