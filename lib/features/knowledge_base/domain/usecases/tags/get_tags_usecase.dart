import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

class GetTagsUseCase {
  final IKnowledgeRepository _repository;

  GetTagsUseCase(this._repository);

  Future<List<TagEntity>> call({String? workspaceId}) async {
    return _repository.getTags(workspaceId: workspaceId);
  }
}
