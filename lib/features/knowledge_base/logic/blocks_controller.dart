import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Controller for Block operations
class BlockController {
  static void Function()? _blocksLoaderDisposable;

  /// Initialize listeners
  static void init() {
    _blocksLoaderDisposable?.call();
    _blocksLoaderDisposable = effect(() {
      final pageId = activePageIdSignal.value;
      if (pageId != null) {
        _loadBlocks(pageId);
      } else {
        blocksSignal.value = AsyncData([]);
      }
    });
  }

  static Future<void> _loadBlocks(String pageId) async {
    blocksSignal.value = AsyncLoading();
    try {
      final repo = knowledgeRepository.value;
      final blocks = await repo.getBlocks(pageId);
      blocksSignal.value = AsyncData(blocks);
    } catch (e, stack) {
      blocksSignal.value = AsyncError(e, stack);
    }
  }

  /// Add a block to the current page
  static Future<void> addBlock(BlockEntity block) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.addBlock(block);

      // Optimistic update or reload
      final current = blocksSignal.value.value;
      if (current != null) {
        // Append locally
        blocksSignal.value = AsyncData([...current, block]);
      } else {
        // Fallback to reload
        await _loadBlocks(block.pageId);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Insert a block after a specific block ID
  static Future<void> insertBlockAfter(
    String afterId,
    BlockEntity newBlock,
  ) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.addBlock(newBlock);

      final current = blocksSignal.value.value;
      if (current != null) {
        final index = current.indexWhere((b) => b.id == afterId);
        if (index != -1) {
          final newList = List<BlockEntity>.from(current);
          newList.insert(index + 1, newBlock);

          // Fix sort orders
          final orderedList = newList.asMap().entries.map((e) {
            return e.value.copyWith(sortOrder: e.key);
          }).toList();

          blocksSignal.value = AsyncData(orderedList);

          // Persist reorder
          await repo.reorderBlocks(
            newBlock.pageId,
            orderedList.map((b) => b.id).toList(),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update a block's content
  static Future<void> updateBlock(BlockEntity block) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.updateBlock(block);

      // Optimistic update
      final current = blocksSignal.value.value;
      if (current != null) {
        final updatedList = current
            .map((b) => b.id == block.id ? block : b)
            .toList();
        blocksSignal.value = AsyncData(updatedList);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a block
  static Future<void> deleteBlock(String blockId) async {
    try {
      final repo = knowledgeRepository.value;
      await repo.deleteBlock(blockId);

      // Optimistic update
      final current = blocksSignal.value.value;
      if (current != null) {
        final updatedList = current.where((b) => b.id != blockId).toList();
        blocksSignal.value = AsyncData(updatedList);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Reorder blocks
  static Future<void> reorderBlocks(List<String> newOrderIds) async {
    final pageId = activePageIdSignal.value;
    if (pageId == null) return;

    // Optimistic local reorder
    final current = blocksSignal.value.value;
    List<BlockEntity>? originalList;

    if (current != null) {
      originalList = List.from(current);
      final blockMap = {for (var b in current) b.id: b};
      final reordered = newOrderIds
          .map((id) => blockMap[id])
          .whereType<BlockEntity>()
          .toList();

      blocksSignal.value = AsyncData(reordered);
    }

    try {
      final repo = knowledgeRepository.value;
      await repo.reorderBlocks(pageId, newOrderIds);
    } catch (e) {
      // Revert if failed
      if (originalList != null) {
        blocksSignal.value = AsyncData(originalList);
      }
      rethrow;
    }
  }
}
