import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class ReorderTasksUseCase {
  final ITaskRepository _repository;

  ReorderTasksUseCase(this._repository);

  Future<void> call(List<TaskEntity> orderedTasks) async {
    await _repository.saveTasks(orderedTasks);
  }
}
