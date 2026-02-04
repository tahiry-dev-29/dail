import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get all workspaces
class GetWorkspacesUseCase {
  final IKnowledgeRepository _repository;

  GetWorkspacesUseCase(this._repository);

  /// Execute the use case
  Future<List<WorkspaceEntity>> call() async {
    return _repository.getWorkspaces();
  }
}
