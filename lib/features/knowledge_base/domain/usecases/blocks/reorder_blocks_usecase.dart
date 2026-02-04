import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Reorder blocks within a page
class ReorderBlocksUseCase {
  final IKnowledgeRepository _repository;

  ReorderBlocksUseCase(this._repository);

  /// Execute the use case
  /// [pageId] The page containing the blocks
  /// [blockIds] New order of block IDs
  Future<void> call(String pageId, List<String> blockIds) async {
    return _repository.reorderBlocks(pageId, blockIds);
  }
}
