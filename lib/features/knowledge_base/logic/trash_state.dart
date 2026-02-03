import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// State for deleted folders
final deletedFoldersSignal = signal<AsyncState<List<FolderEntity>>>(
  AsyncLoading(),
);

/// State for deleted pages
final deletedPagesSignal = signal<AsyncState<List<PageEntity>>>(AsyncLoading());
