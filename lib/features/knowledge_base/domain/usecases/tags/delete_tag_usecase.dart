import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class DeleteTagUseCase {
  final IKnowledgeRepository _repository;

  DeleteTagUseCase(this._repository);

  Future<void> call(String id) async {
    return _repository.deleteTag(id);
  }
}
