import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get pages in a folder
class GetPagesUseCase {
  final IKnowledgeRepository _repository;

  GetPagesUseCase(this._repository);

  /// Execute the use case
  Future<List<PageEntity>> call(String folderId) async {
    return _repository.getPages(folderId);
  }
}
