import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Search pages by query
class SearchPagesUseCase {
  final IKnowledgeRepository _repository;

  SearchPagesUseCase(this._repository);

  /// Execute the use case
  /// [query] Search term for title or content
  Future<List<PageEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return _repository.searchPages(query);
  }
}
