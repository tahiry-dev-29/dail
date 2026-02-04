import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class GetPageByIdUseCase {
  final IKnowledgeRepository _repository;

  GetPageByIdUseCase(this._repository);

  Future<PageEntity?> call(String pageId) async {
    return _repository.getPage(pageId);
  }
}
