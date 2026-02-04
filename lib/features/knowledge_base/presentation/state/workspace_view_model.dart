import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/create_workspace_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/delete_workspace_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/get_workspaces_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/update_workspace_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel for Workspace management
class WorkspaceViewModel {
  // Dependencies
  final GetWorkspacesUseCase _getWorkspacesUseCase;
  final CreateWorkspaceUseCase _createWorkspaceUseCase;
  final UpdateWorkspaceUseCase _updateWorkspaceUseCase;
  final DeleteWorkspaceUseCase _deleteWorkspaceUseCase;

  // State
  final Signal<AsyncState<List<WorkspaceEntity>>> _workspaces = signal(
    const AsyncLoading(),
  );
  final Signal<WorkspaceEntity?> _activeWorkspace = signal(null);

  // Public read-only access
  ReadonlySignal<AsyncState<List<WorkspaceEntity>>> get workspaces =>
      _workspaces;
  ReadonlySignal<WorkspaceEntity?> get activeWorkspace => _activeWorkspace;

  WorkspaceViewModel({
    required GetWorkspacesUseCase getWorkspacesUseCase,
    required CreateWorkspaceUseCase createWorkspaceUseCase,
    required UpdateWorkspaceUseCase updateWorkspaceUseCase,
    required DeleteWorkspaceUseCase deleteWorkspaceUseCase,
  }) : _getWorkspacesUseCase = getWorkspacesUseCase,
       _createWorkspaceUseCase = createWorkspaceUseCase,
       _updateWorkspaceUseCase = updateWorkspaceUseCase,
       _deleteWorkspaceUseCase = deleteWorkspaceUseCase;

  /// Load all workspaces
  Future<void> loadWorkspaces() async {
    _workspaces.value = const AsyncLoading();
    try {
      var list = await _getWorkspacesUseCase();

      // Create default workspace if none exist
      if (list.isEmpty) {
        final defaultWorkspace = WorkspaceEntity(
          id: 'default',
          name: 'My Workspace',
          createdAt: DateTime.now(),
        );
        await _createWorkspaceUseCase(defaultWorkspace);
        list = [defaultWorkspace];
      }

      _workspaces.value = AsyncData(list);

      // Auto-select first workspace if none selected
      if (_activeWorkspace.value == null && list.isNotEmpty) {
        _activeWorkspace.value = list.first;
      }
    } catch (e, stack) {
      _workspaces.value = AsyncError(e, stack);
    }
  }

  /// Set active workspace
  void setActiveWorkspace(WorkspaceEntity workspace) {
    _activeWorkspace.value = workspace;
  }

  /// Create a new workspace
  Future<void> createWorkspace(WorkspaceEntity workspace) async {
    await _createWorkspaceUseCase(workspace);
    await loadWorkspaces();
  }

  /// Update a workspace
  Future<void> updateWorkspace(WorkspaceEntity workspace) async {
    await _updateWorkspaceUseCase(workspace);

    // Update local state
    final current = _workspaces.value.value ?? [];
    final updated = current
        .map((w) => w.id == workspace.id ? workspace : w)
        .toList();
    _workspaces.value = AsyncData(updated);

    // Update active if it was updated
    if (_activeWorkspace.value?.id == workspace.id) {
      _activeWorkspace.value = workspace;
    }
  }

  /// Delete a workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    await _deleteWorkspaceUseCase(workspaceId);

    // Clear active if deleted
    if (_activeWorkspace.value?.id == workspaceId) {
      _activeWorkspace.value = null;
    }

    await loadWorkspaces();
  }

  /// Clear state
  void clear() {
    _workspaces.value = AsyncData([]);
    _activeWorkspace.value = null;
  }
}
