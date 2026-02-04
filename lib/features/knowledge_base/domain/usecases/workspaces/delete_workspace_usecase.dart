import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class DeleteWorkspaceUseCase {
  final IKnowledgeRepository _repository;

  DeleteWorkspaceUseCase(this._repository);

  Future<void> call(String workspaceId) async {
    return _repository.deleteWorkspace(workspaceId);
  }
}
