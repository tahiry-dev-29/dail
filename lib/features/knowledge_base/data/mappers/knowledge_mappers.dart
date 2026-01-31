import 'dart:convert';

import 'package:daily_os/features/knowledge_base/data/dtos/block_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/folder_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/page_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/property_dto.dart';
import 'package:daily_os/features/knowledge_base/data/dtos/workspace_dto.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/folder_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';

/// Mappers between DTOs (database) and Entities (domain)
extension WorkspaceMapper on WorkspaceDTO {
  WorkspaceEntity toEntity() => WorkspaceEntity(
    id: uid,
    name: name,
    iconEmoji: iconEmoji,
    createdAt: createdAt,
  );
}

extension WorkspaceEntityMapper on WorkspaceEntity {
  WorkspaceDTO toDTO() => WorkspaceDTO.create(
    uid: id,
    name: name,
    iconEmoji: iconEmoji,
    createdAt: createdAt,
  );
}

extension FolderMapper on FolderDTO {
  FolderEntity toEntity() => FolderEntity(
    id: uid,
    parentId: parentUid,
    workspaceId: workspaceUid,
    name: name,
    iconEmoji: iconEmoji,
    coverColor: coverColor,
    sortOrder: sortOrder,
    isDeleted: isDeleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension FolderEntityMapper on FolderEntity {
  FolderDTO toDTO() => FolderDTO.create(
    uid: id,
    parentUid: parentId,
    workspaceUid: workspaceId,
    name: name,
    iconEmoji: iconEmoji,
    coverColor: coverColor,
    sortOrder: sortOrder,
    isDeleted: isDeleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension PageMapper on PageDTO {
  PageEntity toEntity({
    List<BlockEntity> blocks = const [],
    List<PropertyEntity> properties = const [],
  }) => PageEntity(
    id: uid,
    folderId: folderUid,
    title: title,
    iconEmoji: iconEmoji,
    coverImageUrl: coverImageUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    blocks: blocks,
    properties: properties,
  );
}

extension PageEntityMapper on PageEntity {
  PageDTO toDTO() => PageDTO.create(
    uid: id,
    folderUid: folderId,
    title: title,
    iconEmoji: iconEmoji,
    coverImageUrl: coverImageUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
  );
}

extension BlockMapper on BlockDTO {
  BlockEntity toEntity() => BlockEntity(
    id: uid,
    pageId: pageUid,
    type: _mapBlockType(type),
    content: json.decode(contentJson) as Map<String, dynamic>,
    sortOrder: sortOrder,
  );

  BlockType _mapBlockType(BlockTypeDTO dto) => switch (dto) {
    BlockTypeDTO.paragraph => .paragraph,
    BlockTypeDTO.heading1 => .heading1,
    BlockTypeDTO.heading2 => .heading2,
    BlockTypeDTO.heading3 => .heading3,
    BlockTypeDTO.checklist => .checklist,
    BlockTypeDTO.image => .image,
    BlockTypeDTO.divider => .divider,
    BlockTypeDTO.quote => .quote,
    BlockTypeDTO.code => .code,
  };
}

extension BlockEntityMapper on BlockEntity {
  BlockDTO toDTO() => BlockDTO.create(
    uid: id,
    pageUid: pageId,
    type: _mapBlockTypeDTO(type),
    contentJson: json.encode(content),
    sortOrder: sortOrder,
  );

  BlockTypeDTO _mapBlockTypeDTO(BlockType type) => switch (type) {
    .paragraph => BlockTypeDTO.paragraph,
    .heading1 => BlockTypeDTO.heading1,
    .heading2 => BlockTypeDTO.heading2,
    .heading3 => BlockTypeDTO.heading3,
    .checklist => BlockTypeDTO.checklist,
    .image => BlockTypeDTO.image,
    .divider => BlockTypeDTO.divider,
    .quote => BlockTypeDTO.quote,
    .code => BlockTypeDTO.code,
  };
}

extension PropertyMapper on PropertyDTO {
  PropertyEntity toEntity() => PropertyEntity(
    id: uid,
    pageId: pageUid,
    name: name,
    type: _mapPropertyType(type),
    value: json.decode(valueJson),
  );

  PropertyType _mapPropertyType(PropertyTypeDTO dto) => switch (dto) {
    PropertyTypeDTO.tags => .tags,
    PropertyTypeDTO.date => .date,
    PropertyTypeDTO.priority => .priority,
    PropertyTypeDTO.status => .status,
    PropertyTypeDTO.number => .number,
    PropertyTypeDTO.text => .text,
    PropertyTypeDTO.checkbox => .checkbox,
    PropertyTypeDTO.select => .select,
    PropertyTypeDTO.multiSelect => .multiSelect,
  };
}

extension PropertyEntityMapper on PropertyEntity {
  PropertyDTO toDTO() => PropertyDTO.create(
    uid: id,
    pageUid: pageId,
    name: name,
    type: _mapPropertyTypeDTO(type),
    valueJson: json.encode(value),
  );

  PropertyTypeDTO _mapPropertyTypeDTO(PropertyType type) => switch (type) {
    .tags => PropertyTypeDTO.tags,
    .date => PropertyTypeDTO.date,
    .priority => PropertyTypeDTO.priority,
    .status => PropertyTypeDTO.status,
    .number => PropertyTypeDTO.number,
    .text => PropertyTypeDTO.text,
    .checkbox => PropertyTypeDTO.checkbox,
    .select => PropertyTypeDTO.select,
    .multiSelect => PropertyTypeDTO.multiSelect,
  };
}
