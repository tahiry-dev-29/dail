import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Create a new page
class CreatePageUseCase {
  final IKnowledgeRepository _repository;

  CreatePageUseCase(this._repository);

  /// Execute the use case
  /// Throws [ArgumentError] if page title is empty
  Future<void> call(PageEntity page) async {
    if (page.title.trim().isEmpty) {
      throw ArgumentError('Page title cannot be empty');
    }
    return _repository.createPage(page);
  }
}
