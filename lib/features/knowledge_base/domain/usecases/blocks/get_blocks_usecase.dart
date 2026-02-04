import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get all blocks for a specific page
class GetBlocksUseCase {
  final IKnowledgeRepository _repository;

  GetBlocksUseCase(this._repository);

  /// Execute the use case
  /// Returns a list of blocks sorted by sortOrder
  Future<List<BlockEntity>> call(String pageId) async {
    final blocks = await _repository.getBlocks(pageId);
    // Sort by sortOrder for consistent display
    blocks.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return blocks;
  }
}
