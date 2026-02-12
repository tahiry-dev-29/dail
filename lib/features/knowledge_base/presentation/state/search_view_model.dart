import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/search_pages_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel for Search functionality
class SearchViewModel {
  SearchViewModel({required SearchPagesUseCase searchPagesUseCase})
    : _searchPagesUseCase = searchPagesUseCase {
    search('');
  }

  // Dependencies
  final SearchPagesUseCase _searchPagesUseCase;

  // State
  final Signal<String> _query = signal('');
  final Signal<AsyncState<List<PageEntity>>> _results = signal(
    const AsyncData([]),
  );
  final Signal<bool> _isSearching = signal(false);

  // Public read-only access
  ReadonlySignal<String> get query => _query;
  ReadonlySignal<AsyncState<List<PageEntity>>> get results => _results;
  ReadonlySignal<bool> get isSearching => _isSearching;

  /// Update search query and perform search
  Future<void> search(String query) async {
    _query.value = query;

    if (query.trim().isEmpty) {
      _results.value = const AsyncData([]);
      _isSearching.value = false;
      return;
    }

    _isSearching.value = true;
    _results.value = const AsyncLoading();

    try {
      final pages = await _searchPagesUseCase(query);
      _results.value = AsyncData(pages);
    } catch (e, stack) {
      _results.value = AsyncError(e, stack);
    } finally {
      _isSearching.value = false;
    }
  }

  /// Clear search
  void clearSearch() {
    _query.value = '';
    _results.value = const AsyncData([]);
    _isSearching.value = false;
  }
}
