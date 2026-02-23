import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskTagPicker extends StatelessWidget {
  final ListSignal<String> selectedTagIds;
  final VoidCallback? onChanged;

  const TaskTagPicker({
    super.key,
    required this.selectedTagIds,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagVM = sl<TagViewModel>();
    final tagsState = tagVM.tags.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TAGS', style: context.caption),
        const SizedBox(height: 12),
        tagsState.map(
          data: (tags) {
            if (tags.isEmpty) {
              return Text(
                'No tags available. Create tags in the Knowledge Base.',
                style: context.bodySmall.copyWith(color: colors.textMuted),
              );
            }

            return Watch((context) {
              final selected = selectedTagIds.watch(context);
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tags.map((tag) {
                  final isSelected = selected.contains(tag.id);
                  final tagColor = _parseColor(tag.color);

                  return _CustomTagChip(
                    label: tag.name,
                    color: tagColor,
                    isSelected: isSelected,
                    onTap: () {
                      if (isSelected) {
                        selectedTagIds.remove(tag.id);
                      } else {
                        selectedTagIds.add(tag.id);
                      }
                      onChanged?.call();
                    },
                  );
                }).toList(),
              );
            });
          },
          error: (e, _) => const Text('Error loading tags'),
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

class _CustomTagChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomTagChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : color.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: context.bodySmall.copyWith(
              color: isSelected ? Colors.white : colors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
