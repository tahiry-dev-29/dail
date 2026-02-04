import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Insert a block after another block and reorder
class InsertBlockAfterUseCase {
  final IKnowledgeRepository _repository;

  InsertBlockAfterUseCase(this._repository);

  /// Execute the use case
  /// [afterBlockId] The block ID after which to insert
  /// [newBlock] The new block to insert
  /// [currentBlocks] Current list of blocks for reordering
  Future<List<BlockEntity>> call({
    required String afterBlockId,
    required BlockEntity newBlock,
    required List<BlockEntity> currentBlocks,
  }) async {
    // Add the new block
    await _repository.addBlock(newBlock);

    // Calculate new order
    final index = currentBlocks.indexWhere((b) => b.id == afterBlockId);
    if (index == -1) {
      // If afterBlockId not found, append at end
      return [...currentBlocks, newBlock];
    }

    // Insert at correct position
    final newList = List<BlockEntity>.from(currentBlocks);
    newList.insert(index + 1, newBlock);

    // Update sort orders
    final orderedList = newList.asMap().entries.map((e) {
      return e.value.copyWith(sortOrder: e.key);
    }).toList();

    // Persist new order
    await _repository.reorderBlocks(
      newBlock.pageId,
      orderedList.map((b) => b.id).toList(),
    );

    return orderedList;
  }
}
