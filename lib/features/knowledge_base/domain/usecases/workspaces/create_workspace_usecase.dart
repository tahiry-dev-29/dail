import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Create a new workspace
class CreateWorkspaceUseCase {
  final IKnowledgeRepository _repository;

  CreateWorkspaceUseCase(this._repository);

  /// Execute the use case
  /// Throws [ArgumentError] if workspace name is empty
  Future<void> call(WorkspaceEntity workspace) async {
    if (workspace.name.trim().isEmpty) {
      throw ArgumentError('Workspace name cannot be empty');
    }
    return _repository.createWorkspace(workspace);
  }
}
