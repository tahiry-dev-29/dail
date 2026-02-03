import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/logic/search_state.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Controller for Search operations
class SearchController {
  /// Perform a search
  static Future<void> search(String query) async {
    searchQuerySignal.value = query;

    if (query.isEmpty) {
      searchResultsSignal.value = AsyncData([]);
      return;
    }

    searchResultsSignal.value = AsyncLoading();

    try {
      final repo = knowledgeRepository.value;
      final results = await repo.searchPages(query);
      searchResultsSignal.value = AsyncData(results);
    } catch (e, stack) {
      searchResultsSignal.value = AsyncError(e, stack);
    }
  }

  /// Clear search results and query
  static void clearSearch() {
    searchQuerySignal.value = '';
    searchResultsSignal.value = AsyncData([]);
  }
}
