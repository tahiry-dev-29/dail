import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class ToggleTaskUseCase {
  final ITaskRepository _repository;

  ToggleTaskUseCase(this._repository);

  Future<void> call(String taskId) async {
    await _repository.toggleTask(taskId);
  }
}
