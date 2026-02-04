import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class UpdateWorkspaceUseCase {
  final IKnowledgeRepository _repository;

  UpdateWorkspaceUseCase(this._repository);

  Future<void> call(WorkspaceEntity workspace) async {
    return _repository.updateWorkspace(workspace);
  }
}
