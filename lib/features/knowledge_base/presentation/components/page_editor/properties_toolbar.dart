import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/property_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/page_properties_view_model.dart';
import 'package:flutter/material.dart';

class PropertiesToolbar extends StatelessWidget {
  final PageEntity page;

  const PropertiesToolbar({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final propertiesVM = sl<PagePropertiesViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (page.properties.isEmpty)
          TextButton.icon(
            onPressed: () => _addInitialProperty(context, propertiesVM),
            icon: Icon(Icons.add, size: 16, color: colors.textSecondary),
            label: Text(
              'Add Property',
              style: context.bodySmall.copyWith(color: colors.textSecondary),
            ),
          )
        else
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: page.properties.map((prop) {
              return _buildPropertyItem(context, prop, propertiesVM);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPropertyItem(
    BuildContext context,
    PropertyEntity prop,
    PagePropertiesViewModel vm,
  ) {
    switch (prop.type) {
      case PropertyType.tags:
        return _buildTagsProperty(context, prop, vm);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTagsProperty(
    BuildContext context,
    PropertyEntity prop,
    PagePropertiesViewModel vm,
  ) {
    final colors = context.colors;
    final tags = prop.tagsValue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.label_outline, size: 14, color: colors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '${prop.name}:',
          style: context.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Wrap(
          spacing: 4,
          children: [
            ...tags.map((tag) => _buildTagChip(context, prop.id, tag, vm)),
            _buildAddTagButton(context, prop.id, vm),
          ],
        ),
      ],
    );
  }

  Widget _buildTagChip(
    BuildContext context,
    String propertyId,
    String tag,
    PagePropertiesViewModel vm,
  ) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: context.bodySmall.copyWith(
              color: colors.accent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => vm.removeTag(propertyId, tag),
            child: Icon(Icons.close, size: 10, color: colors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTagButton(
    BuildContext context,
    String propertyId,
    PagePropertiesViewModel vm,
  ) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => _showAddTagDialog(context, propertyId, vm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colors.textSecondary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        ),
        child: Icon(Icons.add, size: 10, color: colors.textSecondary),
      ),
    );
  }

  void _addInitialProperty(BuildContext context, PagePropertiesViewModel vm) {
    final prop = PropertyEntity.tags(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pageId: page.id,
    );
    vm.addProperty(prop);
  }

  void _showAddTagDialog(
    BuildContext context,
    String propertyId,
    PagePropertiesViewModel vm,
  ) {
    final controller = TextEditingController();
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Add Tag', style: context.bodyLarge),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tag name...'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              vm.addTag(propertyId, value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                vm.addTag(propertyId, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
