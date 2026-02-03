import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';
import 'package:daily_os/features/planner/data/repositories/task_repository_impl.dart';
import 'package:daily_os/features/planner/logic/planner_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Global access to the Planner Controller.
/// In a senior architecture, this facilitates migration from Riverpod
/// while maintaining high-performance reactivity.
final plannerController = PlannerController(
  TaskRepositoryImpl(localDataSource: TaskIsarDataSource()),
);

/// Helper signal for UI initialization status
final isPlannerInitialized = signal(false);

/// Global initialization for the planner feature
Future<void> initPlanner() async {
  if (isPlannerInitialized.value) return;
  await plannerController.init();
  isPlannerInitialized.value = true;
}
