import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class DeleteTaskUseCase {
  final ITaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> call(String taskId) async {
    await _repository.deleteTask(taskId);
  }
}
