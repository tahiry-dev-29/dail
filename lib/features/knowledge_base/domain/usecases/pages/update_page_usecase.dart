import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class UpdatePageUseCase {
  final IKnowledgeRepository _repository;

  UpdatePageUseCase(this._repository);

  Future<void> call(PageEntity page) async {
    return _repository.updatePage(page);
  }
}
