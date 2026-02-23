import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Toggle the favorite status of a page
class TogglePageFavoriteUseCase {
  final IKnowledgeRepository _repository;

  TogglePageFavoriteUseCase(this._repository);

  /// Execute the use case
  Future<void> call(String pageId) async {
    return _repository.togglePageFavorite(pageId);
  }
}
