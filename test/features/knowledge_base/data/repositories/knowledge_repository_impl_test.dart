import 'package:daily_os/features/knowledge_base/data/datasources/local/block_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/folder_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/page_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/property_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/datasources/local/workspace_local_datasource.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/workspace_dto.dart';
import 'package:daily_os/features/knowledge_base/data/repositories/knowledge_repository_impl.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

import 'knowledge_repository_impl_test.mocks.dart';

@GenerateMocks([
  WorkspaceLocalDatasource,
  FolderLocalDatasource,
  PageLocalDatasource,
  BlockLocalDatasource,
  PropertyLocalDatasource,
  Uuid,
])
void main() {
  late KnowledgeRepositoryImpl repository;
  late MockWorkspaceLocalDatasource mockWorkspaceDatasource;
  late MockFolderLocalDatasource mockFolderDatasource;
  late MockPageLocalDatasource mockPageDatasource;
  late MockBlockLocalDatasource mockBlockDatasource;
  late MockPropertyLocalDatasource mockPropertyDatasource;
  late MockUuid mockUuid;

  setUp(() {
    mockWorkspaceDatasource = MockWorkspaceLocalDatasource();
    mockFolderDatasource = MockFolderLocalDatasource();
    mockPageDatasource = MockPageLocalDatasource();
    mockBlockDatasource = MockBlockLocalDatasource();
    mockPropertyDatasource = MockPropertyLocalDatasource();
    mockUuid = MockUuid();

    repository = KnowledgeRepositoryImpl(
      workspaceDatasource: mockWorkspaceDatasource,
      folderDatasource: mockFolderDatasource,
      pageDatasource: mockPageDatasource,
      blockDatasource: mockBlockDatasource,
      propertyDatasource: mockPropertyDatasource,
      uuid: mockUuid,
    );
  });

  group('KnowledgeRepositoryImpl - Workspaces', () {
    final tWorkspaceDto = WorkspaceDTO.create(
      uid: '123',
      name: 'Test Workspace',
      iconEmoji: '🧪',
    );
    final tWorkspaceEntity = WorkspaceEntity(
      id: '123',
      name: 'Test Workspace',
      iconEmoji: '🧪',
      createdAt: tWorkspaceDto.createdAt,
    );

    test('getWorkspaces should return list of workspaces', () async {
      // Arrange
      when(
        mockWorkspaceDatasource.getAll(),
      ).thenAnswer((_) async => [tWorkspaceDto]);

      // Act
      final result = await repository.getWorkspaces();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, tWorkspaceEntity.id);
      expect(result.first.name, tWorkspaceEntity.name);
      verify(mockWorkspaceDatasource.getAll());
    });
  });

  group('KnowledgeRepositoryImpl - Folders', () {
    final tFolderEntity = FolderEntity(
      id: 'folder1',
      parentId: null,
      workspaceId: 'ws1',
      name: 'Test Folder',
      iconEmoji: '📁',
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('createFolder should call save on datasource', () async {
      when(mockFolderDatasource.save(any)).thenAnswer((_) async {
        return;
      });

      await repository.createFolder(tFolderEntity);

      verify(mockFolderDatasource.save(any)).called(1);
    });

    test('getRootFolders should return root folders', () async {
      when(
        mockFolderDatasource.getRootFolders('ws1'),
      ).thenAnswer((_) async => []); // Return empty for simplicity

      await repository.getRootFolders('ws1');

      verify(mockFolderDatasource.getRootFolders('ws1')).called(1);
    });
  });

  group('KnowledgeRepositoryImpl - Pages', () {
    test('softDeletePage should call softDelete on datasource', () async {
      when(mockPageDatasource.softDelete('page1')).thenAnswer((_) async {
        return;
      });

      await repository.deletePage('page1');

      verify(mockPageDatasource.softDelete('page1')).called(1);
    });
  });

  group('KnowledgeRepositoryImpl - Blocks', () {
    test('reorderBlocks should call reorder on datasource', () async {
      when(mockBlockDatasource.reorder('page1', ['b1', 'b2'])).thenAnswer((
        _,
      ) async {
        return;
      });

      await repository.reorderBlocks('page1', ['b1', 'b2']);

      verify(mockBlockDatasource.reorder('page1', ['b1', 'b2'])).called(1);
    });
  });

  group('KnowledgeRepositoryImpl - Trash', () {
    test('restorePage should call restore on datasource', () async {
      when(mockPageDatasource.restore('page1')).thenAnswer((_) async {
        return;
      });

      await repository.restorePage('page1');

      verify(mockPageDatasource.restore('page1')).called(1);
    });
  });
}
