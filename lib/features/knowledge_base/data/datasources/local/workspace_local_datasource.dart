import 'package:daily_os/features/knowledge_base/data/dtos/workspace_dto.dart';
import 'package:daily_os/features/knowledge_base/services/isar_service.dart';
import 'package:isar_community/isar.dart';

/// Local datasource for Workspace CRUD operations
class WorkspaceLocalDatasource {
  /// Get all workspaces
  Future<List<WorkspaceDTO>> getAll() async {
    final isar = await IsarService.instance;
    return isar.workspaceDTOs.where().findAll();
  }

  /// Get workspace by UID
  Future<WorkspaceDTO?> getByUid(String uid) async {
    final isar = await IsarService.instance;
    return isar.workspaceDTOs.filter().uidEqualTo(uid).findFirst();
  }

  /// Create or update a workspace
  Future<void> save(WorkspaceDTO workspace) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      final existing = await isar.workspaceDTOs
          .filter()
          .uidEqualTo(workspace.uid)
          .findFirst();
      if (existing != null) {
        workspace.id = existing.id;
      }
      await isar.workspaceDTOs.put(workspace);
    });
  }

  /// Delete a workspace by UID
  Future<void> delete(String uid) async {
    final isar = await IsarService.instance;
    await isar.writeTxn(() async {
      await isar.workspaceDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  /// Create default workspace if none exists
  Future<WorkspaceDTO> getOrCreateDefault() async {
    final workspaces = await getAll();
    if (workspaces.isNotEmpty) return workspaces.first;

    final defaultWorkspace = WorkspaceDTO.create(
      uid: 'default-workspace',
      name: 'My Workspace',
      iconEmoji: '📚',
    );
    await save(defaultWorkspace);
    return defaultWorkspace;
  }
}
