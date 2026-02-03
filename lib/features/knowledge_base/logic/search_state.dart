import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// State for search results
final searchResultsSignal = signal<AsyncState<List<PageEntity>>>(AsyncData([]));

/// State for search query
final searchQuerySignal = signal<String>('');
