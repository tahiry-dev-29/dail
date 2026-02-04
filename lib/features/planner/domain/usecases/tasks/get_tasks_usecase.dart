import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class GetTasksUseCase {
  final ITaskRepository _repository;

  GetTasksUseCase(this._repository);

  Future<List<TaskEntity>> call() async {
    return await _repository.getTasks();
  }
}
