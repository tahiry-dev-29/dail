import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get root folders for a workspace
class GetRootFoldersUseCase {
  final IKnowledgeRepository _repository;

  GetRootFoldersUseCase(this._repository);

  /// Execute the use case
  Future<List<FolderEntity>> call(String workspaceId) async {
    return _repository.getRootFolders(workspaceId);
  }
}
