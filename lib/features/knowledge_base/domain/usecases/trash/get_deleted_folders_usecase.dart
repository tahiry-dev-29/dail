import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class GetDeletedFoldersUseCase {
  final IKnowledgeRepository _repository;

  GetDeletedFoldersUseCase(this._repository);

  Future<List<FolderEntity>> call() async {
    return _repository.getDeletedFolders();
  }
}
