import 'package:daily_os/features/knowledge_base/data/dtos/block_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/property_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/workspace_dto.dart';
import 'package:daily_os/features/planner/data/dtos/subtask_dto.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Singleton manager for Isar database.
/// This ensures a single instance of Isar is used across the entire application.
class IsarDatabase {
  static IsarDatabase? _instance;
  static IsarDatabase get instance => _instance ??= IsarDatabase._();

  IsarDatabase._();

  Isar? _isar;

  /// Get the current Isar instance.
  /// Throws if not initialized.
  Isar get isar {
    if (_isar == null) {
      throw StateError('IsarDatabase not initialized. Call init() first.');
    }
    return _isar!;
  }

  /// Initialize the Isar database with all required schemas.
  Future<void> init() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        // Planner schemas
        TaskDTOSchema,
        SubTaskDTOSchema,

        // Knowledge Base schemas
        WorkspaceDTOSchema,
        FolderDTOSchema,
        PageDTOSchema,
        BlockDTOSchema,
        PropertyDTOSchema,
      ],
      directory: dir.path,
      inspector: true, // Enable Isar Inspector for debugging
    );
  }

  /// Close the database connection.
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
