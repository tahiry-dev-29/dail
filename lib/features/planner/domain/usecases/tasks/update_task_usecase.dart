import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class UpdateTaskUseCase {
  final ITaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<void> call(TaskEntity task) async {
    if (task.name.trim().isEmpty) {
      throw Exception('Task name cannot be empty');
    }
    await _repository.updateTask(task);
  }
}
