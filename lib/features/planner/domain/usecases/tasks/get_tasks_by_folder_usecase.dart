import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class GetTasksByFolderUseCase {
  final ITaskRepository _repository;

  GetTasksByFolderUseCase(this._repository);

  Future<List<TaskEntity>> call(String folderId) async {
    return await _repository.getTasksByFolder(folderId);
  }
}
