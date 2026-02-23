import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/create_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/delete_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/get_page_by_id_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/pages/update_page_usecase.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/block_view_model.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// ViewModel for Active Page management
class ActivePageViewModel {
  // Dependencies
  final UpdatePageUseCase _updatePageUseCase;
  final DeletePageUseCase _deletePageUseCase;
  final GetPageByIdUseCase _getPageByIdUseCase;
  final CreatePageUseCase _createPageUseCase;
  final BlockViewModel _blockVM;

  // State
  final Signal<String?> _activePageId = signal(null);
  final Signal<AsyncState<PageEntity?>> _activePage = signal(
    const AsyncData(null),
  );

  // Public read-only access
  ReadonlySignal<String?> get activePageId => _activePageId;
  ReadonlySignal<AsyncState<PageEntity?>> get activePage => _activePage;

  ActivePageViewModel({
    required UpdatePageUseCase updatePageUseCase,
    required DeletePageUseCase deletePageUseCase,
    required GetPageByIdUseCase getPageByIdUseCase,
    required CreatePageUseCase createPageUseCase,
    required BlockViewModel blockVM,
  }) : _updatePageUseCase = updatePageUseCase,
       _deletePageUseCase = deletePageUseCase,
       _getPageByIdUseCase = getPageByIdUseCase,
       _createPageUseCase = createPageUseCase,
       _blockVM = blockVM;

  /// Set active page ID and load the page AND its blocks
  Future<void> setActivePageId(String? pageId) async {
    _activePageId.value = pageId;

    if (pageId == null) {
      _activePage.value = const AsyncData(null);
      _blockVM.clear(); // Clear blocks
      return;
    }

    // Trigger block loading immediately
    _blockVM.loadBlocks(pageId);

    _activePage.value = const AsyncLoading();
    try {
      final page = await _getPageByIdUseCase(pageId);
      _activePage.value = AsyncData(page);
    } catch (e, stack) {
      _activePage.value = AsyncError(e, stack);
    }
  }

  /// Reload the active page
  Future<void> reloadActivePage() async {
    final pageId = _activePageId.value;
    if (pageId != null) {
      await setActivePageId(pageId);
    }
  }

  /// Update the active page locally (optimistic update)
  void updateActivePageLocally(PageEntity page) {
    if (_activePageId.value == page.id) {
      _activePage.value = AsyncData(page);
    }
  }

  /// Update page title
  Future<void> updateTitle(String title) async {
    final currentPage = _activePage.value.value;
    if (currentPage == null) return;

    final updatedPage = currentPage.copyWith(title: title);
    _activePage.value = AsyncData(updatedPage);
    await _updatePageUseCase(updatedPage);
  }

  /// Update page icon
  Future<void> updateIcon(String iconEmoji) async {
    final currentPage = _activePage.value.value;
    if (currentPage == null) return;

    final updatedPage = currentPage.copyWith(iconEmoji: iconEmoji);
    _activePage.value = AsyncData(updatedPage);
    await _updatePageUseCase(updatedPage);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite() async {
    final currentPage = _activePage.value.value;
    if (currentPage == null) return;

    final updatedPage = currentPage.copyWith(
      isFavorite: !currentPage.isFavorite,
    );
    _activePage.value = AsyncData(updatedPage);
    await _updatePageUseCase(updatedPage);
  }

  /// Move page to another folder
  Future<void> movePage(String targetFolderId) async {
    final currentPage = _activePage.value.value;
    if (currentPage == null) return;

    final updatedPage = currentPage.copyWith(folderId: targetFolderId);
    _activePage.value = AsyncData(updatedPage);
    await _updatePageUseCase(updatedPage);
  }

  /// Create a new page in a folder and select it
  Future<void> createNewPage(String folderId) async {
    final newPage = PageEntity(
      id: Uuid().v4(),
      folderId: folderId,
      title: 'Untitled',
      iconEmoji: '📄',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Use the CreatePageUseCase
    await _createPageUseCase(newPage);
    await setActivePageId(newPage.id);
  }

  /// Delete a page by ID
  Future<void> deletePage(String pageId) async {
    await _deletePageUseCase(pageId);
    if (_activePageId.value == pageId) {
      clear();
    }
  }

  /// Delete the active page
  Future<void> deleteActivePage() async {
    final pageId = _activePageId.value;
    if (pageId != null) {
      await deletePage(pageId);
    }
  }

  /// Clear state
  void clear() {
    _activePageId.value = null;
    _activePage.value = const AsyncData(null);
  }
}
