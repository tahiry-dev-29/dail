import 'package:daily_os/features/planner/data/dtos/task_dto.dart';

abstract class ITaskLocalDataSource {
  Future<List<TaskDTO>> getTasks();
  Future<void> saveTasks(List<TaskDTO> tasks);
}

class TaskLocalDataSource implements ITaskLocalDataSource {
  // In a real implementation, this would use Isar or Hive.
  // For now, we interact with a mock persistent storage (or memory).
  List<TaskDTO> _mockDatabase = [];

  @override
  Future<List<TaskDTO>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate IO
    return _mockDatabase;
  }

  @override
  Future<void> saveTasks(List<TaskDTO> tasks) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate IO
    _mockDatabase = tasks;
  }
}
