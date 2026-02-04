import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class RestoreFolderUseCase {
  final IKnowledgeRepository _repository;

  RestoreFolderUseCase(this._repository);

  Future<void> call(String folderId) async {
    return _repository.restoreFolder(folderId);
  }
}
