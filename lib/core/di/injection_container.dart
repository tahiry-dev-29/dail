import 'package:daily_os/features/ai_chat/presentation/state/ai_chat_view_model.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:daily_os/features/home/presentation/state/dashboard_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/block_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/folder_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/page_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/property_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/tag_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/workspace_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/repositories/knowledge_repository_impl.dart';
import 'package:daily_os/features/knowledge_base/data/services/voice_service_impl.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:daily_os/features/knowledge_base/domain/services/voice_service.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/add_block_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/delete_block_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/get_blocks_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/insert_block_after_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/reorder_blocks_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/update_block_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/create_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/delete_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_child_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/get_root_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/move_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/folders/update_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/create_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/delete_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_page_by_id_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_recent_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/reorder_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/search_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/update_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/properties/property_usecases.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/create_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/delete_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/get_tags_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/tags/update_tag_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/empty_trash_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/get_deleted_folders_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/get_deleted_pages_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/permanently_delete_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/permanently_delete_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/restore_folder_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/trash/restore_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/create_workspace_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/delete_workspace_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/get_workspaces_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/workspaces/update_workspace_usecase.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/folder_tree_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/page_properties_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/recent_list_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/search_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/trash_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/knowledge_base/services/isar_service.dart';
import 'package:daily_os/features/planner/data/datasources/local/task_local_datasource.dart';
import 'package:daily_os/features/planner/data/repositories/task_repository_impl.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/domain/repositories/i_task_repository.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/add_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/auto_ignore_overdue_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/check_task_overdue_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/delete_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/get_tasks_by_folder_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/reorder_tasks_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/toggle_task_usecase.dart';
import 'package:daily_os/features/planner/domain/usecases/tasks/update_task_usecase.dart';
import 'package:daily_os/features/planner/presentation/state/stats_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/features/settings/presentation/state/settings_view_model.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Locator instance for Dependency Injection
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this in main() before runApp()
Future<void> initDependencies() async {
  // ============ 1. Core & Services ============
  final isar = await IsarService.instance;
  sl.registerSingleton<Isar>(isar);

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);

  // ============ 2. Data Sources ============
  // Knowledge Base
  sl.registerLazySingleton(() => WorkspaceLocalDatasource(sl()));
  sl.registerLazySingleton(() => FolderLocalDatasource(sl()));
  sl.registerLazySingleton(() => PageLocalDatasource(sl()));
  sl.registerLazySingleton(() => BlockLocalDatasource(sl()));
  sl.registerLazySingleton(() => PropertyLocalDatasource(sl()));
  sl.registerLazySingleton(() => TagLocalDatasource(sl()));

  // Planner
  sl.registerLazySingleton<ITaskLocalDataSource>(
    () => TaskLocalDataSource(sl()),
  );

  sl.registerLazySingleton<IVoiceService>(() => VoiceServiceImpl());

  // ============ 3. Repositories ============
  sl.registerLazySingleton<IKnowledgeRepository>(
    () => KnowledgeRepositoryImpl(
      workspaceDatasource: sl(),
      folderDatasource: sl(),
      pageDatasource: sl(),
      blockDatasource: sl(),
      propertyDatasource: sl(),
      tagDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<ITaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // ============ 4. Use Cases ============
  // Knowledge Base
  sl.registerFactory(() => GetBlocksUseCase(sl()));
  sl.registerFactory(() => AddBlockUseCase(sl()));
  sl.registerFactory(() => UpdateBlockUseCase(sl()));
  sl.registerFactory(() => DeleteBlockUseCase(sl()));
  sl.registerFactory(() => ReorderBlocksUseCase(sl()));
  sl.registerFactory(() => InsertBlockAfterUseCase(sl()));

  // UseCases - Folders
  sl.registerFactory(() => GetRootFoldersUseCase(sl()));
  sl.registerFactory(() => GetChildFoldersUseCase(sl()));
  sl.registerFactory(() => MoveFolderUseCase(sl()));
  sl.registerFactory(() => CreateFolderUseCase(sl()));
  sl.registerFactory(() => UpdateFolderUseCase(sl()));
  sl.registerFactory(() => DeleteFolderUseCase(sl()));

  // UseCases - Pages
  sl.registerFactory(() => GetPagesUseCase(sl()));
  sl.registerFactory(() => CreatePageUseCase(sl()));
  sl.registerFactory(() => SearchPagesUseCase(sl()));
  sl.registerFactory(() => UpdatePageUseCase(sl()));
  sl.registerFactory(() => DeletePageUseCase(sl()));
  sl.registerFactory(() => GetPageByIdUseCase(sl()));
  sl.registerFactory(() => GetRecentPagesUseCase(sl()));
  sl.registerFactory(() => ReorderPagesUseCase(sl()));

  // UseCases - Workspaces
  sl.registerFactory(() => GetWorkspacesUseCase(sl()));
  sl.registerFactory(() => CreateWorkspaceUseCase(sl()));
  sl.registerFactory(() => UpdateWorkspaceUseCase(sl()));
  sl.registerFactory(() => DeleteWorkspaceUseCase(sl()));

  // UseCases - Trash
  sl.registerFactory(() => GetDeletedFoldersUseCase(sl()));
  sl.registerFactory(() => GetDeletedPagesUseCase(sl()));
  sl.registerFactory(() => RestoreFolderUseCase(sl()));
  sl.registerFactory(() => RestorePageUseCase(sl()));
  sl.registerFactory(() => PermanentlyDeleteFolderUseCase(sl()));
  sl.registerFactory(() => PermanentlyDeletePageUseCase(sl()));
  sl.registerFactory(() => EmptyTrashUseCase(sl()));

  // UseCases - Properties
  sl.registerFactory(() => GetPropertiesUseCase(sl()));
  sl.registerFactory(() => AddPropertyUseCase(sl()));
  sl.registerFactory(() => UpdatePropertyUseCase(sl()));
  sl.registerFactory(() => DeletePropertyUseCase(sl()));

  // UseCases - Tags
  sl.registerFactory(() => GetTagsUseCase(sl()));
  sl.registerFactory(() => CreateTagUseCase(sl()));
  sl.registerFactory(() => UpdateTagUseCase(sl()));
  sl.registerFactory(() => DeleteTagUseCase(sl()));

  // Planner
  sl.registerFactory(() => GetTasksByFolderUseCase(sl()));
  sl.registerFactory(() => GetTasksUseCase(sl()));
  sl.registerFactory(() => AddTaskUseCase(sl()));
  sl.registerFactory(() => UpdateTaskUseCase(sl()));
  sl.registerFactory(() => DeleteTaskUseCase(sl()));
  sl.registerFactory(() => ToggleTaskUseCase(sl()));
  sl.registerFactory(() => ReorderTasksUseCase(sl()));
  sl.registerFactory(() => CheckTaskOverdueUseCase());
  sl.registerFactory(() => AutoIgnoreOverdueTasksUseCase(sl(), sl()));

  // ============ 5. View Models ============
  // Knowledge Base
  sl.registerLazySingleton(
    () => BlockViewModel(
      getBlocksUseCase: sl(),
      addBlockUseCase: sl(),
      updateBlockUseCase: sl(),
      deleteBlockUseCase: sl(),
      reorderBlocksUseCase: sl(),
      insertBlockAfterUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FolderTreeViewModel(
      getRootFoldersUseCase: sl(),
      createFolderUseCase: sl(),
      updateFolderUseCase: sl(),
      deleteFolderUseCase: sl(),
      getChildFoldersUseCase: sl(),
      moveFolderUseCase: sl(),
      getPagesUseCase: sl(),
      getTasksByFolderUseCase: sl(),
      reorderPagesUseCase: sl(),
      workspaceVM: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => WorkspaceViewModel(
      getWorkspacesUseCase: sl(),
      createWorkspaceUseCase: sl(),
      updateWorkspaceUseCase: sl(),
      deleteWorkspaceUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ActivePageViewModel(
      updatePageUseCase: sl(),
      deletePageUseCase: sl(),
      getPageByIdUseCase: sl(),
      createPageUseCase: sl(),
      blockVM: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => TrashViewModel(
      getDeletedFoldersUseCase: sl(),
      getDeletedPagesUseCase: sl(),
      restoreFolderUseCase: sl(),
      restorePageUseCase: sl(),
      permanentlyDeleteFolderUseCase: sl(),
      permanentlyDeletePageUseCase: sl(),
      emptyTrashUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SearchViewModel(searchPagesUseCase: sl()));
  sl.registerLazySingleton(
    () => RecentListViewModel(getRecentPagesUseCase: sl()),
  );

  sl.registerLazySingleton(
    () => TagViewModel(
      getTagsUseCase: sl(),
      createTagUseCase: sl(),
      updateTagUseCase: sl(),
      deleteTagUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => PagePropertiesViewModel(
      addPropertyUseCase: sl(),
      updatePropertyUseCase: sl(),
      deletePropertyUseCase: sl(),
      activePageVM: sl(),
      tagVM: sl(),
    ),
  );

  // Calendar
  sl.registerLazySingleton(() => CalendarViewModel());

  // Home
  sl.registerLazySingleton(() => HomeViewModel());
  sl.registerLazySingleton(() => DashboardViewModel(sl()));
  sl.registerLazySingleton(() => AiChatViewModel());

  // Settings
  sl.registerLazySingleton(() => ThemeViewModel(sl()));
  sl.registerLazySingleton(() => SettingsViewModel(sl()));

  // Planner
  sl.registerLazySingleton(
    () => TaskListViewModel(
      getTasksUseCase: sl(),
      addTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
      toggleTaskUseCase: sl(),
      reorderTasksUseCase: sl(),
      workspaceVM: sl(),
      calendarVM: sl(),
    ),
  );

  sl.registerLazySingleton(() => StatsViewModel(sl<TaskListViewModel>()));

  sl.registerFactoryParam<TaskEditViewModel, TaskEntity, void>(
    (task, _) => TaskEditViewModel(task, sl<TaskListViewModel>()),
  );
}

/// Bootstrap initial data loading.
/// Called once from [main.dart] after DI is ready and UI is mounted.
void bootstrapAppData() {
  Future.microtask(() {
    sl<TaskListViewModel>().loadTasks();
    sl<WorkspaceViewModel>().loadWorkspaces();
    sl<TagViewModel>().loadTags();
  });
}
