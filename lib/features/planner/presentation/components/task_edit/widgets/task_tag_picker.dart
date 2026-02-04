import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskTagPicker extends StatelessWidget {
  final ListSignal<String> selectedTagIds;

  const TaskTagPicker({super.key, required this.selectedTagIds});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagVM = sl<TagViewModel>();
    final tagsState = tagVM.tags.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TAGS', style: context.caption),
        const SizedBox(height: 8),
        tagsState.map(
          data: (tags) {
            if (tags.isEmpty) {
              return Text(
                'No tags available. Create tags in the Knowledge Base.',
                style: context.bodySmall.copyWith(color: colors.textMuted),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                final isSelected = selectedTagIds.contains(tag.id);
                final tagColor = _parseColor(tag.color);

                return FilterChip(
                  label: Text(
                    tag.name,
                    style: context.bodySmall.copyWith(
                      color: isSelected ? Colors.white : colors.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      selectedTagIds.add(tag.id);
                    } else {
                      selectedTagIds.remove(tag.id);
                    }
                  },
                  backgroundColor: tagColor.withValues(alpha: 0.1),
                  selectedColor: tagColor,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : colors.border,
                    ),
                  ),
                );
              }).toList(),
            );
          },
          error: (e, _) => Text('Error loading tags'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return Colors.grey;
    try {
      final hex = colorStr.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}
