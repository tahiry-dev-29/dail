import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// State for the list of workspaces
final workspacesSignal = signal<AsyncState<List<WorkspaceEntity>>>(
  AsyncLoading(),
);

/// State for the currently active workspace
final activeWorkspaceSignal = signal<WorkspaceEntity?>(null);
