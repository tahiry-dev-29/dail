import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/logic/workspace_state.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// Controller for Workspace operations
class WorkspaceController {
  /// Load all workspaces and set default if needed
  static Future<void> loadWorkspaces() async {
    workspacesSignal.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final workspaces = await repo.getWorkspaces();

      // If no workspaces, create default
      if (workspaces.isEmpty) {
        final defaultWorkspace = WorkspaceEntity(
          id: const Uuid().v4(),
          name: 'My Workspace',
          iconEmoji: '📚',
          createdAt: DateTime.now(),
        );
        await repo.createWorkspace(defaultWorkspace);
        workspacesSignal.value = AsyncData([defaultWorkspace]);
        activeWorkspaceSignal.value = defaultWorkspace;
      } else {
        workspacesSignal.value = AsyncData(workspaces);
        // Set first as active if none selected
        if (activeWorkspaceSignal.value == null) {
          activeWorkspaceSignal.value = workspaces.first;
        }
      }
    } catch (e, stack) {
      workspacesSignal.value = AsyncError(e, stack);
    }
  }

  /// Select a workspace by ID
  static void selectWorkspace(String id) {
    final currentState = workspacesSignal.value;
    if (currentState is AsyncData<List<WorkspaceEntity>>) {
      final list = currentState.value;
      final found = list.where((w) => w.id == id).firstOrNull;
      if (found != null) {
        activeWorkspaceSignal.value = found;
      }
    }
  }

  /// Create a new workspace
  static Future<void> createWorkspace({
    required String name,
    required String iconEmoji,
  }) async {
    try {
      final repo = knowledgeRepository.value;
      final newWorkspace = WorkspaceEntity(
        id: const Uuid().v4(),
        name: name,
        iconEmoji: iconEmoji,
        createdAt: DateTime.now(),
      );
      await repo.createWorkspace(newWorkspace);

      // Reload or update list manually
      await loadWorkspaces();

      // Select the new workspace
      activeWorkspaceSignal.value = newWorkspace;
    } catch (e) {
      // Handle error (maybe show a toast or set an error signal)
      rethrow;
    }
  }

  /// Update an existing workspace
  static Future<void> updateWorkspace(WorkspaceEntity workspace) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.updateWorkspace(workspace);
      await loadWorkspaces();

      // If the updated workspace was active, update the active signal reference
      if (activeWorkspaceSignal.value?.id == workspace.id) {
        activeWorkspaceSignal.value = workspace;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a workspace
  static Future<void> deleteWorkspace(String id) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.deleteWorkspace(id);
      await loadWorkspaces();

      // If active workspace was deleted, select another one
      if (activeWorkspaceSignal.value?.id == id) {
        final currentState = workspacesSignal.value;
        if (currentState is AsyncData<List<WorkspaceEntity>>) {
          final list = currentState.value;
          if (list.isNotEmpty) {
            activeWorkspaceSignal.value = list.first;
          } else {
            activeWorkspaceSignal.value = null;
          }
        } else {
          activeWorkspaceSignal.value = null;
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
