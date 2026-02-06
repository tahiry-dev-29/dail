import 'package:daily_os/features/planner/domain/entities/task_entity.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<List<TaskEntity>> getTasksByFolder(String folderId);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> toggleTask(String id);
  Future<void> saveTasks(List<TaskEntity> tasks);
}
