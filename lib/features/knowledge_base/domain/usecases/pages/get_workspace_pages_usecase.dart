import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get all pages in a workspace
class GetWorkspacePagesUseCase {
  final IKnowledgeRepository _repository;

  GetWorkspacePagesUseCase(this._repository);

  /// Execute the use case
  Future<List<PageEntity>> call(String workspaceId) async {
    return _repository.getWorkspacePages(workspaceId);
  }
}
