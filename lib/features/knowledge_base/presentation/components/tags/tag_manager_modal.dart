import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class TagManagerModal extends HookWidget {
  const TagManagerModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TagManagerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagVM = sl<TagViewModel>();
    final tagsState = tagVM.tags.watch(context);
    final activeWorkspace = sl<WorkspaceViewModel>().activeWorkspace.watch(
      context,
    );

    // Editing state
    final editingTagId = useState<String?>(null);
    final nameController = useTextEditingController();
    final selectedColor = useState<String>('#3B82F6'); // Default Blue

    // Available colors
    final tagColors = [
      '#EF4444', // Red
      '#F97316', // Orange
      '#EAB308', // Yellow
      '#22C55E', // Green
      '#3B82F6', // Blue
      '#A855F7', // Purple
      '#EC4899', // Pink
      '#64748B', // Slate
    ];

    void startEditing(TagEntity? tag) {
      if (tag != null) {
        editingTagId.value = tag.id;
        nameController.text = tag.name;
        selectedColor.value = tag.color;
      } else {
        editingTagId.value = 'new';
        nameController.text = '';
        selectedColor.value = tagColors[4];
      }
    }

    void cancelEditing() {
      editingTagId.value = null;
      nameController.clear();
    }

    Future<void> saveTag() async {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      if (editingTagId.value == 'new') {
        final newTag = TagEntity(
          id: const Uuid().v4(),
          name: name,
          color: selectedColor.value,
          workspaceId: activeWorkspace?.id,
          createdAt: DateTime.now(),
        );
        await tagVM.createTag(newTag);
      } else {
        final existing = tagsState.value?.firstWhere(
          (t) => t.id == editingTagId.value,
        );
        if (existing != null) {
          await tagVM.updateTag(
            existing.copyWith(name: name, color: selectedColor.value),
          );
        }
      }
      cancelEditing();
    }

    Future<void> deleteTag(String id) async {
      await tagVM.deleteTag(id, workspaceId: activeWorkspace?.id);
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manage Tags',
                style: context.h2.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // Editor
          if (editingTagId.value != null) ...[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tag Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: context.bodyMedium.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tagColors.map((color) {
                  final isSelected = selectedColor.value == color;
                  return GestureDetector(
                    onTap: () => selectedColor.value = color,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(color.substring(1), radix: 16) + 0xFF000000,
                        ),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: colors.textPrimary, width: 2)
                            : null,
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: cancelEditing,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: saveTag,
                  child: Text(editingTagId.value == 'new' ? 'Create' : 'Save'),
                ),
              ],
            ),
            const Divider(),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () => startEditing(null),
              icon: const Icon(Icons.add),
              label: const Text('Create New Tag'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // List
          Expanded(
            child: tagsState.map(
              data: (tags) {
                if (tags.isEmpty) {
                  return Center(
                    child: Text(
                      'No tags yet',
                      style: context.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: tags.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final tag = tags[index];
                    Color tagColor = colors.accent;
                    try {
                      if (tag.color.startsWith('#')) {
                        tagColor = Color(
                          int.parse(tag.color.substring(1), radix: 16) +
                              0xFF000000,
                        );
                      }
                    } catch (_) {}

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: tagColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(
                        tag.name,
                        style: context.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                              color: colors.textSecondary,
                            ),
                            onPressed: () => startEditing(tag),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 18,
                              color: colors.error,
                            ),
                            onPressed: () => deleteTag(tag.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (e, _) => Center(child: Text('Error: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
