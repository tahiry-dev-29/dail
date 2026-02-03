import 'package:daily_os/core/storage/isar_database.dart';
import 'package:daily_os/features/planner/data/dtos/subtask_dto.dart';
import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:isar_community/isar.dart';

abstract class ITaskLocalDataSource {
  Future<List<TaskDTO>> getTasks();
  Future<void> saveTasks(List<TaskDTO> tasks);
  Future<void> addTask(TaskDTO task);
  Future<void> updateTask(TaskDTO task);
  Future<void> deleteTask(String uid);

  // Subtasks
  Future<List<SubTaskDTO>> getSubTasks(String taskUid);
  Future<void> saveSubTask(SubTaskDTO subtask);
  Future<void> deleteSubTask(String uid);
}

class TaskIsarDataSource implements ITaskLocalDataSource {
  Isar get isar => IsarDatabase.instance.isar;

  @override
  Future<List<TaskDTO>> getTasks() async {
    return isar.taskDTOs.where().findAll();
  }

  @override
  Future<void> saveTasks(List<TaskDTO> tasks) async {
    await isar.writeTxn(() async {
      // Upsert logic
      for (final task in tasks) {
        final existing = await isar.taskDTOs
            .where()
            .uidEqualTo(task.uid)
            .findFirst();
        if (existing != null) {
          task.id = existing.id;
        }
      }
      await isar.taskDTOs.putAll(tasks);
    });
  }

  @override
  Future<void> addTask(TaskDTO task) async {
    await isar.writeTxn(() async {
      await isar.taskDTOs.put(task);
    });
  }

  @override
  Future<void> updateTask(TaskDTO task) async {
    await isar.writeTxn(() async {
      final existing = await isar.taskDTOs
          .where()
          .uidEqualTo(task.uid)
          .findFirst();
      if (existing != null) {
        task.id = existing.id;
      }
      await isar.taskDTOs.put(task);
    });
  }

  @override
  Future<void> deleteTask(String uid) async {
    await isar.writeTxn(() async {
      await isar.taskDTOs.where().uidEqualTo(uid).deleteAll();
      // Also delete orphan subtasks
      await isar.subTaskDTOs.where().taskUidEqualTo(uid).deleteAll();
    });
  }

  @override
  Future<List<SubTaskDTO>> getSubTasks(String taskUid) async {
    return isar.subTaskDTOs.where().taskUidEqualTo(taskUid).findAll();
  }

  @override
  Future<void> saveSubTask(SubTaskDTO subtask) async {
    await isar.writeTxn(() async {
      final existing = await isar.subTaskDTOs
          .where()
          .uidEqualTo(subtask.uid)
          .findFirst();
      if (existing != null) {
        subtask.id = existing.id;
      }
      await isar.subTaskDTOs.put(subtask);
    });
  }

  @override
  Future<void> deleteSubTask(String uid) async {
    await isar.writeTxn(() async {
      await isar.subTaskDTOs.where().uidEqualTo(uid).deleteAll();
    });
  }
}
