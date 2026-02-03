import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';
import 'package:daily_os/features/planner/data/dtos/subtask_dto.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final taskDtos = await localDataSource.getTasks();
    final List<TaskEntity> entities = [];

    for (final dto in taskDtos) {
      final subtasks = await localDataSource.getSubTasks(dto.uid);
      final entity = dto.toEntity().copyWith(
        subtasks: subtasks.map((st) => st.toEntity()).toList(),
      );
      entities.add(entity);
    }
    return entities;
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await localDataSource.addTask(TaskDTO.fromEntity(task));
    for (final st in task.subtasks) {
      await localDataSource.saveSubTask(
        SubTaskDTO.fromEntity(st)..taskUid = task.id,
      );
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await localDataSource.updateTask(TaskDTO.fromEntity(task));

    // Simplification: Clear and rewrite subtasks for the task
    // (A more advanced implementation would diff them)
    // Actually, let's just save them normally.
    for (final st in task.subtasks) {
      final dto = SubTaskDTO.fromEntity(st);
      dto.taskUid = task.id;
      await localDataSource.saveSubTask(dto);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> toggleTask(String id) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = tasks[index];
      await updateTask(task.copyWith(isDone: !task.isDone));
    }
  }

  @override
  Future<void> saveTasks(List<TaskEntity> tasks) async {
    // Used for bulk reordering usually
    final dtos = tasks.map((t) => TaskDTO.fromEntity(t)).toList();
    await localDataSource.saveTasks(dtos);
  }
}
