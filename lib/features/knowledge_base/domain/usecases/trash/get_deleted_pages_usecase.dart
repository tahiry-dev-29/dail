import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class GetDeletedPagesUseCase {
  final IKnowledgeRepository _repository;

  GetDeletedPagesUseCase(this._repository);

  Future<List<PageEntity>> call() async {
    return _repository.getDeletedPages();
  }
}
