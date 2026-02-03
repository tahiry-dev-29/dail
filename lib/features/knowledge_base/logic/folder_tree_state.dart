import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// State for root folders of the active workspace
final rootFoldersSignal = signal<AsyncState<List<FolderEntity>>>(
  AsyncLoading(),
);

/// Cache of children signals for each folder (lazy loading)
/// Public so controller can access it
final folderChildrenCache = <String, Signal<AsyncState<List<FolderEntity>>>>{};

/// Cache of pages signals for each folder (lazy loading)
/// Public so controller can access it
final folderPagesCache = <String, Signal<AsyncState<List<PageEntity>>>>{};

/// Set of expanded folder IDs
final expandedFoldersSignal = signal<Set<String>>({});
