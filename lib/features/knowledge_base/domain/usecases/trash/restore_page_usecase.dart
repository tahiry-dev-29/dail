import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class RestorePageUseCase {
  final IKnowledgeRepository _repository;

  RestorePageUseCase(this._repository);

  Future<void> call(String pageId) async {
    return _repository.restorePage(pageId);
  }
}
