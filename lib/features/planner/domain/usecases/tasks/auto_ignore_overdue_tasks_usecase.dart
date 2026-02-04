import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/check_task_overdue_usecase.dart';

/// Use case that identifies and automatically ignores overdue tasks.
class AutoIgnoreOverdueTasksUseCase {
  final ITaskRepository _repository;
  final CheckTaskOverdueUseCase _checkOverdue;

  AutoIgnoreOverdueTasksUseCase(this._repository, this._checkOverdue);

  Future<void> call() async {
    final tasks = await _repository.getTasks();
    final now = DateTime.now();
    final updatedTasks = <TaskEntity>[];

    for (var task in tasks) {
      if (_checkOverdue(task, now)) {
        updatedTasks.add(task.copyWith(isIgnored: true));
      }
    }

    if (updatedTasks.isNotEmpty) {
      // Save all updated tasks back to the repository
      await _repository.saveTasks(updatedTasks);
    }
  }
}
