import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';
import 'package:daily_os/features/knowledge_base/logic/knowledge_repository_provider.dart';
import 'package:daily_os/features/knowledge_base/logic/search_state.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/command_bar/search_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'search_modal_test.mocks.dart';

@GenerateMocks([IKnowledgeRepository])
void main() {
  late MockIKnowledgeRepository mockRepository;

  setUp(() {
    mockRepository = MockIKnowledgeRepository();
    knowledgeRepository.value = mockRepository;

    // Reset signals
    searchQuerySignal.value = '';
    searchResultsSignal.value = AsyncData([]);
  });

  testWidgets('SearchModal displays results when items are found', (
    WidgetTester tester,
  ) async {
    final tPage = PageEntity(
      id: 'p1',
      folderId: 'f1',
      title: 'Search Result Content',
      iconEmoji: '🔍',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(mockRepository.searchPages('search')).thenAnswer((_) async => [tPage]);

    await tester.pumpWidget(const MaterialApp(home: SearchModal()));

    // Initial state
    expect(find.text('Type to search...'), findsOneWidget);

    // Enter search text
    await tester.enterText(find.byType(TextField), 'search');
    await tester.pump(); // Trigger onChanged
    await tester.pump(); // Trigger search and microtasks

    // Verify repository called
    verify(mockRepository.searchPages('search')).called(1);

    // Verify result displayed
    expect(find.text('Search Result Content'), findsOneWidget);
  });
}
