import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/planner/domain/entities/subtask_entity.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart' as sig;

/// Provider to manage the reorderable state of active tasks.
/// This is used instead of signals for the drag-and-drop feature
/// to avoid reactive glitches with ReorderableList.
class ActiveTasksNotifier extends Notifier<AsyncValue<List<TaskEntity>>> {
  @override
  AsyncValue<List<TaskEntity>> build() {
    final signal = sl<TaskListViewModel>().activeTasks;

    // 1. Initial State mapping
    final sigState = signal.value;
    AsyncValue<List<TaskEntity>> initialState = _mapSignalToRiverpod(sigState);

    // 2. Subscribe to signals for automatic synchronization
    final dispose = signal.subscribe((stateValue) {
      state = _mapSignalToRiverpod(stateValue);
    });

    ref.onDispose(dispose);
    return initialState;
  }

  /// Helper to convert Signals AsyncState to Riverpod AsyncValue
  AsyncValue<List<TaskEntity>> _mapSignalToRiverpod(
    sig.AsyncState<List<TaskEntity>> sigState,
  ) {
    if (sigState is sig.AsyncData<List<TaskEntity>>) {
      return AsyncValue.data(sigState.value);
    } else if (sigState is sig.AsyncError<List<TaskEntity>>) {
      return AsyncValue.error(sigState.error, sigState.stackTrace);
    } else {
      return const AsyncValue.loading();
    }
  }

  /// Handles reordering within the active list.
  /// Updates local state for instant feedback and notifies the ViewModel to persist.
  void reorder(int oldIndex, int newIndex) {
    final currentTasks = state.value;
    if (currentTasks == null) return;

    final list = [...currentTasks];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    // 1. Instant UI update via Riverpod
    state = AsyncData(list);

    // 2. Persist via ViewModel (which handles mapping back to the full list)
    // We pass the new full list construction logic through the VM's specialized method.
    sl<TaskListViewModel>().onReorderActiveTasks(oldIndex, newIndex);
  }
}

final activeTasksProvider =
    NotifierProvider<ActiveTasksNotifier, AsyncValue<List<TaskEntity>>>(
      ActiveTasksNotifier.new,
    );

/// Notifier for expired tasks reordering.
class ExpiredTasksNotifier extends Notifier<AsyncValue<List<TaskEntity>>> {
  @override
  AsyncValue<List<TaskEntity>> build() {
    final signal = sl<TaskListViewModel>().expiredTasks;
    final sigState = signal.value;
    AsyncValue<List<TaskEntity>> initialState = _mapSignalToRiverpod(sigState);

    final dispose = signal.subscribe((stateValue) {
      state = _mapSignalToRiverpod(stateValue);
    });

    ref.onDispose(dispose);
    return initialState;
  }

  AsyncValue<List<TaskEntity>> _mapSignalToRiverpod(
    sig.AsyncState<List<TaskEntity>> sigState,
  ) {
    if (sigState is sig.AsyncData<List<TaskEntity>>) {
      return AsyncValue.data(sigState.value);
    } else if (sigState is sig.AsyncError<List<TaskEntity>>) {
      return AsyncValue.error(sigState.error, sigState.stackTrace);
    } else {
      return const AsyncValue.loading();
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final currentTasks = state.value;
    if (currentTasks == null) return;

    final list = [...currentTasks];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    state = AsyncData(list);
    // Note: Persisting reorder for expired tasks might need a specialized method if they are treated differently.
    // For now, we assume global reorder logic in VM handles it.
  }
}

final expiredTasksProvider =
    NotifierProvider<ExpiredTasksNotifier, AsyncValue<List<TaskEntity>>>(
      ExpiredTasksNotifier.new,
    );

/// Notifier for completed tasks reordering.
class CompletedTasksNotifier extends Notifier<AsyncValue<List<TaskEntity>>> {
  @override
  AsyncValue<List<TaskEntity>> build() {
    final signal = sl<TaskListViewModel>().completedTasks;
    final sigState = signal.value;
    AsyncValue<List<TaskEntity>> initialState = _mapSignalToRiverpod(sigState);

    final dispose = signal.subscribe((stateValue) {
      state = _mapSignalToRiverpod(stateValue);
    });

    ref.onDispose(dispose);
    return initialState;
  }

  AsyncValue<List<TaskEntity>> _mapSignalToRiverpod(
    sig.AsyncState<List<TaskEntity>> sigState,
  ) {
    if (sigState is sig.AsyncData<List<TaskEntity>>) {
      return AsyncValue.data(sigState.value);
    } else if (sigState is sig.AsyncError<List<TaskEntity>>) {
      return AsyncValue.error(sigState.error, sigState.stackTrace);
    } else {
      return const AsyncValue.loading();
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final currentTasks = state.value;
    if (currentTasks == null) return;

    final list = [...currentTasks];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    state = AsyncData(list);
  }
}

final completedTasksProvider =
    NotifierProvider<CompletedTasksNotifier, AsyncValue<List<TaskEntity>>>(
      CompletedTasksNotifier.new,
    );

/// Notifier for subtasks reordering within TaskEditPage.
class SubtasksNotifier extends Notifier<List<SubTaskEntity>> {
  final String taskId;
  SubtasksNotifier(this.taskId);

  @override
  List<SubTaskEntity> build() {
    return [];
  }

  void init(List<SubTaskEntity> initialList) {
    state = initialList;
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final list = [...state];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = list;
  }
}

final subtasksProvider =
    NotifierProvider.family<SubtasksNotifier, List<SubTaskEntity>, String>(
      SubtasksNotifier.new,
    );
