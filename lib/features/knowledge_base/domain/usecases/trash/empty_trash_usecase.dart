import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class EmptyTrashUseCase {
  final IKnowledgeRepository _repository;

  EmptyTrashUseCase(this._repository);

  Future<void> call() async {
    return _repository.emptyTrash();
  }
}
