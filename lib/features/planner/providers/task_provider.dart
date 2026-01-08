import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../planner/data/task_model.dart';

class TaskNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    // Initial Mock Data
    return [
      const Task(id: '1', name: 'Morning Routine', time: '07:00', isDone: true),
      const Task(id: '2', name: 'Deep Work', time: '09:00', isDone: false),
      const Task(id: '3', name: 'Gym', time: '18:00', isDone: false),
    ];
  }

  void addTask(String name, String time) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      time: time,
    );
    state = [...state, newTask]..sort((a, b) => a.time.compareTo(b.time));
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);
