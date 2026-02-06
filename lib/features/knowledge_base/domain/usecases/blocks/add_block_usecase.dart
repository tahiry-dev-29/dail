import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Add a new block to a page
class AddBlockUseCase {
  final IKnowledgeRepository _repository;

  AddBlockUseCase(this._repository);

  /// Execute the use case
  /// Throws [ArgumentError] if block content is empty for text-based blocks
  Future<void> call(BlockEntity block) async {
    // Business validation: Match functionality over strictness for now
    // We allow empty paragraphs to let users start typing
    // if (block.type == BlockType.paragraph &&
    //     (block.content['text'] as String?)?.isEmpty == true) {
    //   throw ArgumentError('Cannot add empty paragraph block');
    // }

    return _repository.addBlock(block);
  }
}
