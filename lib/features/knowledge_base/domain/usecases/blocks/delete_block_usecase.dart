import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Delete a block by ID
class DeleteBlockUseCase {
  final IKnowledgeRepository _repository;

  DeleteBlockUseCase(this._repository);

  /// Execute the use case
  Future<void> call(String blockId) async {
    return _repository.deleteBlock(blockId);
  }
}
