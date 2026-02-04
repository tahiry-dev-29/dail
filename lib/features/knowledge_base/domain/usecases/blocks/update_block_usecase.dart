import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Update an existing block
class UpdateBlockUseCase {
  final IKnowledgeRepository _repository;

  UpdateBlockUseCase(this._repository);

  /// Execute the use case
  Future<void> call(BlockEntity block) async {
    return _repository.updateBlock(block);
  }
}
