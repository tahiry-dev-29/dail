import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Delete a folder (soft delete)
class DeleteFolderUseCase {
  final IKnowledgeRepository _repository;

  DeleteFolderUseCase(this._repository);

  /// Execute the use case - moves folder to trash
  Future<void> call(String folderId) async {
    return _repository.deleteFolder(folderId);
  }
}
