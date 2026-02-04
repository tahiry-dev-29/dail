import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class CreateTagUseCase {
  final IKnowledgeRepository _repository;

  CreateTagUseCase(this._repository);

  Future<void> call(TagEntity tag) async {
    return _repository.createTag(tag);
  }
}
