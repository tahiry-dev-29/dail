import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:daily_os/features/knowledge_base/logic/folder_tree_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/folder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'folder_tile_test.mocks.dart';

@GenerateMocks([IKnowledgeRepository])
void main() {
  late MockIKnowledgeRepository mockRepository;

  setUp(() {
    mockRepository = MockIKnowledgeRepository();
    // Inject mock repository
    knowledgeRepository.value = mockRepository;
    // Reset state
    expandedFoldersSignal.value = {};
    folderChildrenCache.clear();
  });

  testWidgets('FolderTile toggles expansion on tap', (
    WidgetTester tester,
  ) async {
    final tFolder = FolderEntity(
      id: 'f1',
      parentId: null,
      workspaceId: 'ws1',
      name: 'Test Folder',
      iconEmoji: '📁',
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Stub getChildFolders to avoid error during lazy load
    when(mockRepository.getChildFolders('f1')).thenAnswer((_) async => []);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FolderTile(folder: tFolder, isExpanded: false, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Test Folder'), findsOneWidget);
    expect(find.text('📁'), findsOneWidget);

    // Tap to toggle
    await tester.tap(find.byType(FolderTile));
    await tester.pump();

    // Verify signal updated
    expect(expandedFoldersSignal.value.contains('f1'), true);
  });
}
