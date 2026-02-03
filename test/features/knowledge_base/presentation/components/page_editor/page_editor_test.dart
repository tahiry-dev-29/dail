import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_state.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'page_editor_test.mocks.dart';

@GenerateMocks([IKnowledgeRepository])
void main() {
  late MockIKnowledgeRepository mockRepository;

  setUp(() {
    mockRepository = MockIKnowledgeRepository();
    knowledgeRepository.value = mockRepository;

    // Reset state
    activePageSignal.value = AsyncLoading();
    blocksSignal.value = AsyncLoading();
  });

  testWidgets('PageEditor shows "No page selected" when page is null', (
    WidgetTester tester,
  ) async {
    activePageSignal.value = AsyncData(null);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: PageEditor())),
    );

    expect(find.text('No page selected'), findsOneWidget);
  });

  testWidgets('PageEditor shows content when page is loaded', (
    WidgetTester tester,
  ) async {
    final tPage = PageEntity(
      id: 'p1',
      folderId: 'f1',
      title: 'Test Page',
      iconEmoji: '📄',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockRepository.getPage('p1')).thenAnswer((_) async => tPage);
    when(mockRepository.getBlocks('p1')).thenAnswer((_) async => []);

    // Set high-level signal
    activePageIdSignal.value = 'p1';

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: PageEditor())),
    );

    // Give time for effects and async loading
    await tester.pump(); // initState -> init() effects
    await tester.pump(); // Async loading tasks

    expect(find.text('Test Page'), findsOneWidget);
    expect(find.text('Start typing...'), findsOneWidget);
  });
}
