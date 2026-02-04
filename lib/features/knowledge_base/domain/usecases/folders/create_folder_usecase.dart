import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Create a new folder
class CreateFolderUseCase {
  final IKnowledgeRepository _repository;

  CreateFolderUseCase(this._repository);

  /// Execute the use case
  /// Throws [ArgumentError] if folder name is empty
  Future<void> call(FolderEntity folder) async {
    if (folder.name.trim().isEmpty) {
      throw ArgumentError('Folder name cannot be empty');
    }
    return _repository.createFolder(folder);
  }
}
