import 'package:daily_os/features/planner/data/dtos/task_dto.dart';
import 'package:isar_community/isar.dart';

abstract class ITaskLocalDataSource {
  Future<List<TaskDTO>> getTasks();
  Future<List<TaskDTO>> getTasksByFolder(String folderId);
  Future<void> saveTask(TaskDTO task);
  Future<void> saveTasks(List<TaskDTO> tasks);
  Future<void> deleteTask(String uid);
}

class TaskLocalDataSource implements ITaskLocalDataSource {
  final Isar isar;

  TaskLocalDataSource(this.isar);

  @override
  Future<List<TaskDTO>> getTasks() async {
    return isar.taskDTOs.where().sortBySortOrder().findAll();
  }

  @override
  Future<List<TaskDTO>> getTasksByFolder(String folderId) async {
    final results = await isar.taskDTOs
        .filter()
        .folderIdEqualTo(folderId)
        .sortBySortOrder()
        .findAll();
    return results;
  }

  Future<void> reorder(List<String> uids) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < uids.length; i++) {
        final task = await isar.taskDTOs
            .filter()
            .uidEqualTo(uids[i])
            .findFirst();
        if (task != null) {
          task.sortOrder = i;
          await isar.taskDTOs.put(task);
        }
      }
    });
  }

  @override
  Future<void> saveTask(TaskDTO task) async {
    await isar.writeTxn(() async {
      final existing = await isar.taskDTOs
          .filter()
          .uidEqualTo(task.uid)
          .findFirst();

      if (existing != null) {
        task.id = existing.id;
      }

      await isar.taskDTOs.put(task);
    });
  }

  @override
  Future<void> saveTasks(List<TaskDTO> tasks) async {
    await isar.writeTxn(() async {
      for (var task in tasks) {
        final existing = await isar.taskDTOs
            .filter()
            .uidEqualTo(task.uid)
            .findFirst();

        if (existing != null) {
          task.id = existing.id;
        }
        await isar.taskDTOs.put(task);
      }
    });
  }

  @override
  Future<void> deleteTask(String uid) async {
    await isar.writeTxn(() async {
      await isar.taskDTOs.filter().uidEqualTo(uid).deleteAll();
    });
  }
}
