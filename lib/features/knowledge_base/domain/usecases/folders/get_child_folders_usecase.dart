import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class GetChildFoldersUseCase {
  final IKnowledgeRepository repository;

  GetChildFoldersUseCase(this.repository);

  Future<List<FolderEntity>> call(String parentId) {
    return repository.getChildFolders(parentId);
  }
}
