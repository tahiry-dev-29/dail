import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_recent_pages_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel for Recent Pages list
class RecentListViewModel {
  final GetRecentPagesUseCase _getRecentPagesUseCase;

  // State
  final Signal<AsyncState<List<PageEntity>>> _recentPages = signal(
    const AsyncLoading(),
  );

  // Public read-only access
  ReadonlySignal<AsyncState<List<PageEntity>>> get recentPages => _recentPages;

  RecentListViewModel({required GetRecentPagesUseCase getRecentPagesUseCase})
    : _getRecentPagesUseCase = getRecentPagesUseCase;

  /// Load recently updated pages
  Future<void> loadRecentPages({int limit = 10}) async {
    _recentPages.value = const AsyncLoading();
    try {
      final list = await _getRecentPagesUseCase(limit: limit);
      _recentPages.value = AsyncData(list);
    } catch (e, stack) {
      _recentPages.value = AsyncError(e, stack);
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    await loadRecentPages();
  }
}
