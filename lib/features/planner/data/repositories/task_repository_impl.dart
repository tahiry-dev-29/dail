import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';
import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final dtos = await localDataSource.getTasks();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final tasks = await localDataSource.getTasks();
    tasks.add(TaskDTO.fromEntity(task));
    await localDataSource.saveTasks(tasks);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final tasks = await localDataSource.getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = TaskDTO.fromEntity(task);
      await localDataSource.saveTasks(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDataSource.getTasks();
    tasks.removeWhere((t) => t.id == id);
    await localDataSource.saveTasks(tasks);
  }

  @override
  Future<void> toggleTask(String id) async {
    final tasks = await localDataSource.getTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = tasks[index];
      tasks[index] = task.copyWith(isDone: !task.isDone);
      await localDataSource.saveTasks(tasks);
    }
  }

  @override
  Future<void> saveTasks(List<TaskEntity> tasks) async {
    final dtos = tasks.map((t) => TaskDTO.fromEntity(t)).toList();
    await localDataSource.saveTasks(dtos);
  }
}

extension TaskDTOCopyWith on TaskDTO {
  TaskDTO copyWith({bool? isDone}) {
    return TaskDTO(
      id: id,
      name: name,
      description: description,
      time: time,
      isDone: isDone ?? this.isDone,
      date: date,
      deadline: deadline,
      isFavorite: isFavorite,
      isIgnored: isIgnored,
      subtasks: subtasks,
    );
  }
}
