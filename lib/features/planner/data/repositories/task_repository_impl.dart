import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final dtos = await localDataSource.getTasks();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByFolder(String folderId) async {
    final dtos = await localDataSource.getTasksByFolder(folderId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await localDataSource.saveTask(TaskDTO.fromEntity(task));
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await localDataSource.saveTask(TaskDTO.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> toggleTask(String id) async {
    // Inefficient but safe: fetch all, find, toggle, save.
    // Ideally DataSource should support getById or proper partial update.
    final dtos = await localDataSource.getTasks();
    final taskDto = dtos.cast<TaskDTO?>().firstWhere(
      (t) => t?.uid == id,
      orElse: () => null,
    );

    if (taskDto != null) {
      taskDto.isDone = !taskDto.isDone;
      await localDataSource.saveTask(taskDto);
    }
  }

  @override
  Future<void> saveTasks(List<TaskEntity> tasks) async {
    // Used for reordering or bulk updates
    // Assign indices as sortOrder to persist the current list order
    final dtos = tasks.asMap().entries.map((entry) {
      final index = entry.key;
      final task = entry.value;
      return TaskDTO.fromEntity(task.copyWith(sortOrder: index));
    }).toList();
    await localDataSource.saveTasks(dtos);
  }
}
