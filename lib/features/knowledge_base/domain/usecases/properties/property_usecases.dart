import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/repositories/i_knowledge_repository.dart';

/// UseCase: Get properties for a page
class GetPropertiesUseCase {
  final IKnowledgeRepository _repository;
  GetPropertiesUseCase(this._repository);
  Future<List<PropertyEntity>> call(String pageId) =>
      _repository.getProperties(pageId);
}

/// UseCase: Add a property to a page
class AddPropertyUseCase {
  final IKnowledgeRepository _repository;
  AddPropertyUseCase(this._repository);
  Future<void> call(PropertyEntity property) =>
      _repository.addProperty(property);
}

/// UseCase: Update a property
class UpdatePropertyUseCase {
  final IKnowledgeRepository _repository;
  UpdatePropertyUseCase(this._repository);
  Future<void> call(PropertyEntity property) =>
      _repository.updateProperty(property);
}

/// UseCase: Delete a property
class DeletePropertyUseCase {
  final IKnowledgeRepository _repository;
  DeletePropertyUseCase(this._repository);
  Future<void> call(String propertyId) =>
      _repository.deleteProperty(propertyId);
}
