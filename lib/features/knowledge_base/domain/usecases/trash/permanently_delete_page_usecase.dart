import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class PermanentlyDeletePageUseCase {
  final IKnowledgeRepository _repository;

  PermanentlyDeletePageUseCase(this._repository);

  Future<void> call(String pageId) async {
    return _repository.permanentlyDeletePage(pageId);
  }
}
