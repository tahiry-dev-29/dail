import 'package:daily_os/features/knowledge_base/data/repositories/knowledge_repository_impl.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Global signal providing access to the Knowledge Base repository
///
/// This is a lazy-initialized singleton that provides access to all
/// Knowledge Base operations (workspaces, folders, pages, blocks, properties)
final knowledgeRepository = signal<IKnowledgeRepository>(
  KnowledgeRepositoryImpl(),
);
