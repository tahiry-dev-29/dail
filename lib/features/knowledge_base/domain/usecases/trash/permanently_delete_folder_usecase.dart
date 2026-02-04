import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class PermanentlyDeleteFolderUseCase {
  final IKnowledgeRepository _repository;

  PermanentlyDeleteFolderUseCase(this._repository);

  Future<void> call(String folderId) async {
    return _repository.permanentlyDeleteFolder(folderId);
  }
}
