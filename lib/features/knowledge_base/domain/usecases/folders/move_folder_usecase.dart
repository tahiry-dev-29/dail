import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class MoveFolderUseCase {
  final IKnowledgeRepository repository;

  MoveFolderUseCase(this.repository);

  Future<void> call(String folderId, String? newParentId) {
    return repository.moveFolder(folderId, newParentId);
  }
}
