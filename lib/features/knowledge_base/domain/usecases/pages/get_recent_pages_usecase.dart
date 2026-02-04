import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get recently updated pages
class GetRecentPagesUseCase {
  final IKnowledgeRepository _repository;

  GetRecentPagesUseCase(this._repository);

  /// Execute the use case
  Future<List<PageEntity>> call({int limit = 10}) async {
    return _repository.getRecentPages(limit: limit);
  }
}
