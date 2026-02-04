import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/usecases/properties/property_usecases.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';

/// ViewModel for managing page properties (Tags, Status, etc.)
class PagePropertiesViewModel {
  final AddPropertyUseCase _addPropertyUseCase;
  final UpdatePropertyUseCase _updatePropertyUseCase;
  final DeletePropertyUseCase _deletePropertyUseCase;
  final ActivePageViewModel _activePageVM;
  final TagViewModel _tagVM;

  PagePropertiesViewModel({
    required AddPropertyUseCase addPropertyUseCase,
    required UpdatePropertyUseCase updatePropertyUseCase,
    required DeletePropertyUseCase deletePropertyUseCase,
    required ActivePageViewModel activePageVM,
    required TagViewModel tagVM,
  }) : _addPropertyUseCase = addPropertyUseCase,
       _updatePropertyUseCase = updatePropertyUseCase,
       _deletePropertyUseCase = deletePropertyUseCase,
       _activePageVM = activePageVM,
       _tagVM = tagVM;

  /// Add a new property to the active page
  Future<void> addProperty(PropertyEntity property) async {
    await _addPropertyUseCase(property);
    await _activePageVM.reloadActivePage();
  }

  /// Update a property value
  Future<void> updateProperty(PropertyEntity property) async {
    await _updatePropertyUseCase(property);

    // Optimistic update in active page
    final currentPage = _activePageVM.activePage.value.value;
    if (currentPage != null) {
      final updatedProperties = currentPage.properties
          .map((p) => p.id == property.id ? property : p)
          .toList();
      _activePageVM.updateActivePageLocally(
        currentPage.copyWith(properties: updatedProperties),
      );
    }

    // Refresh global tags list if it's a tags property
    if (property.type == PropertyType.tags) {
      _tagVM.loadTags();
    }
  }

  /// Delete a property
  Future<void> deleteProperty(String propertyId) async {
    await _deletePropertyUseCase(propertyId);
    await _activePageVM.reloadActivePage();
  }

  /// Add a tag to a tags property
  Future<void> addTag(String propertyId, String tag) async {
    final currentPage = _activePageVM.activePage.value.value;
    if (currentPage == null) return;

    final property = currentPage.properties.firstWhere(
      (p) => p.id == propertyId,
    );
    if (property.type != PropertyType.tags) return;

    final currentTags = property.tagsValue;
    if (currentTags.contains(tag)) return;

    final updatedProperty = property.copyWith(value: [...currentTags, tag]);
    await updateProperty(updatedProperty);
  }

  /// Remove a tag
  Future<void> removeTag(String propertyId, String tag) async {
    final currentPage = _activePageVM.activePage.value.value;
    if (currentPage == null) return;

    final property = currentPage.properties.firstWhere(
      (p) => p.id == propertyId,
    );
    final currentTags = property.tagsValue;

    final updatedProperty = property.copyWith(
      value: currentTags.where((t) => t != tag).toList(),
    );
    await updateProperty(updatedProperty);
  }
}
