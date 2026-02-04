import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Update an existing folder
class UpdateFolderUseCase {
  final IKnowledgeRepository _repository;

  UpdateFolderUseCase(this._repository);

  /// Execute the use case
  Future<void> call(FolderEntity folder) async {
    return _repository.updateFolder(folder);
  }
}
