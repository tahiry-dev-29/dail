import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class ReorderPagesUseCase {
  final IKnowledgeRepository _repository;

  ReorderPagesUseCase(this._repository);

  Future<void> call(String folderId, List<String> pageIds) async {
    await _repository.reorderPages(folderId, pageIds);
  }
}
