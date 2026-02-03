import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'block_controller_test.mocks.dart';

@GenerateMocks([IKnowledgeRepository])
void main() {
  late MockIKnowledgeRepository mockRepository;

  setUp(() {
    mockRepository = MockIKnowledgeRepository();
    knowledgeRepository.value = mockRepository;

    // Reset signals
    activePageIdSignal.value = null;
    blocksSignal.value = AsyncData([]);
  });

  group('BlockController', () {
    final tBlock = BlockEntity(
      id: 'b1',
      pageId: 'p1',
      type: BlockType.paragraph,
      content: {'text': 'Hello'},
      sortOrder: 0,
    );

    test('init should load blocks when activePageId changes', () async {
      // Arrange
      when(mockRepository.getBlocks('p1')).thenAnswer((_) async => [tBlock]);

      BlockController.init();

      // Act
      activePageIdSignal.value = 'p1';

      // Wait for effect to trigger and async load to complete
      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);

      // Assert
      expect(blocksSignal.value.value, [tBlock]);
      verify(mockRepository.getBlocks('p1')).called(1);
    });

    test('addBlock should update list and call repository', () async {
      // Arrange
      blocksSignal.value = AsyncData([]);
      when(mockRepository.addBlock(tBlock)).thenAnswer((_) async {});

      // Act
      await BlockController.addBlock(tBlock);

      // Assert
      expect(blocksSignal.value.value, [tBlock]);
      verify(mockRepository.addBlock(tBlock)).called(1);
    });

    test('deleteBlock should remove from list and call repository', () async {
      // Arrange
      blocksSignal.value = AsyncData([tBlock]);
      when(mockRepository.deleteBlock('b1')).thenAnswer((_) async {});

      // Act
      await BlockController.deleteBlock('b1');

      // Assert
      expect(blocksSignal.value.value, []);
      verify(mockRepository.deleteBlock('b1')).called(1);
    });
  });
}
