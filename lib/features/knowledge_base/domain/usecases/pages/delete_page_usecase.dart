import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class DeletePageUseCase {
  final IKnowledgeRepository _repository;

  DeletePageUseCase(this._repository);

  Future<void> call(String pageId) async {
    return _repository.deletePage(pageId);
  }
}
