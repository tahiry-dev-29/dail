import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/add_block_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/delete_block_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/get_blocks_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/insert_block_after_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/reorder_blocks_usecase.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/blocks/update_block_usecase.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel for Block operations
///
/// Replaces the static [BlockController] with proper dependency injection.
/// All dependencies are explicitly injected via constructor.
class BlockViewModel {
  // Dependencies (injected)
  final GetBlocksUseCase _getBlocksUseCase;
  final AddBlockUseCase _addBlockUseCase;
  final UpdateBlockUseCase _updateBlockUseCase;
  final DeleteBlockUseCase _deleteBlockUseCase;
  final ReorderBlocksUseCase _reorderBlocksUseCase;
  final InsertBlockAfterUseCase _insertBlockAfterUseCase;

  // State
  final Signal<AsyncState<List<BlockEntity>>> _blocks = signal(
    const AsyncLoading(),
  );
  final Signal<String?> _currentPageId = signal(null);

  // Public read-only access to state
  ReadonlySignal<AsyncState<List<BlockEntity>>> get blocks => _blocks;
  ReadonlySignal<String?> get currentPageId => _currentPageId;

  BlockViewModel({
    required GetBlocksUseCase getBlocksUseCase,
    required AddBlockUseCase addBlockUseCase,
    required UpdateBlockUseCase updateBlockUseCase,
    required DeleteBlockUseCase deleteBlockUseCase,
    required ReorderBlocksUseCase reorderBlocksUseCase,
    required InsertBlockAfterUseCase insertBlockAfterUseCase,
  }) : _getBlocksUseCase = getBlocksUseCase,
       _addBlockUseCase = addBlockUseCase,
       _updateBlockUseCase = updateBlockUseCase,
       _deleteBlockUseCase = deleteBlockUseCase,
       _reorderBlocksUseCase = reorderBlocksUseCase,
       _insertBlockAfterUseCase = insertBlockAfterUseCase;

  /// Load blocks for a specific page
  Future<void> loadBlocks(String pageId) async {
    _currentPageId.value = pageId;
    _blocks.value = const AsyncLoading();

    try {
      final result = await _getBlocksUseCase(pageId);
      _blocks.value = AsyncData(result);
    } catch (e, stack) {
      _blocks.value = AsyncError(e, stack);
    }
  }

  /// Add a new block to the current page
  Future<void> addBlock(BlockEntity block) async {
    final currentList = _blocks.value.value ?? [];

    // Optimistic update
    _blocks.value = AsyncData([...currentList, block]);

    try {
      await _addBlockUseCase(block);
    } catch (e) {
      // Rollback on error
      _blocks.value = AsyncData(currentList);
      rethrow;
    }
  }

  /// Insert a block after a specific block ID
  Future<void> insertBlockAfter(String afterId, BlockEntity newBlock) async {
    final currentList = _blocks.value.value ?? [];

    try {
      final updatedList = await _insertBlockAfterUseCase(
        afterBlockId: afterId,
        newBlock: newBlock,
        currentBlocks: currentList,
      );
      _blocks.value = AsyncData(updatedList);
    } catch (e) {
      // Reload on error to ensure consistency
      if (_currentPageId.value != null) {
        await loadBlocks(_currentPageId.value!);
      }
      rethrow;
    }
  }

  /// Update a block's content
  Future<void> updateBlock(BlockEntity block) async {
    final currentList = _blocks.value.value ?? [];

    // Optimistic update
    final updatedList = currentList
        .map((b) => b.id == block.id ? block : b)
        .toList();
    _blocks.value = AsyncData(updatedList);

    try {
      await _updateBlockUseCase(block);
    } catch (e) {
      // Rollback on error
      _blocks.value = AsyncData(currentList);
      rethrow;
    }
  }

  /// Delete a block
  Future<void> deleteBlock(String blockId) async {
    final currentList = _blocks.value.value ?? [];

    // Optimistic update
    final updatedList = currentList.where((b) => b.id != blockId).toList();
    _blocks.value = AsyncData(updatedList);

    try {
      await _deleteBlockUseCase(blockId);
    } catch (e) {
      // Rollback on error
      _blocks.value = AsyncData(currentList);
      rethrow;
    }
  }

  /// Reorder blocks
  Future<void> reorderBlocks(List<String> newOrderIds) async {
    final pageId = _currentPageId.value;
    if (pageId == null) return;

    final currentList = _blocks.value.value ?? [];

    // Optimistic local reorder
    final blockMap = {for (var b in currentList) b.id: b};
    final reordered = newOrderIds
        .map((id) => blockMap[id])
        .whereType<BlockEntity>()
        .toList();
    _blocks.value = AsyncData(reordered);

    try {
      await _reorderBlocksUseCase(pageId, newOrderIds);
    } catch (e) {
      // Rollback on error
      _blocks.value = AsyncData(currentList);
      rethrow;
    }
  }

  /// Clear state (when navigating away)
  void clear() {
    _currentPageId.value = null;
    _blocks.value = AsyncData([]);
  }
}
