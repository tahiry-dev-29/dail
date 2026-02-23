import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:daily_os/features/planner/views/bloc/task_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Bottom sheet view for selecting tags and searching tasks globally in the workspace.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = sl<TaskListViewModel>().searchQuery.value;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final taskVM = sl<TaskListViewModel>();
    final tagVM = sl<TagViewModel>();

    final tagsState = tagVM.tags.watch(context);
    final selectedTagIds = taskVM.selectedTagIds.watch(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrer',
                    style: AppTypography.h2.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Input
              Text(
                'Rechercher',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Titre de la tâche...',
                  hintStyle: TextStyle(
                    color: colors.textSecondary.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: colors.textPrimary),
                onChanged: (val) => taskVM.searchQuery.value = val,
              ),
              const SizedBox(height: 24),

              // Tags Selection
              Text(
                'Tags',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (tagsState is AsyncData<List<TagEntity>>) ...[
                if (tagsState.requireValue.isEmpty)
                  Text(
                    'Aucun tag disponible',
                    style: TextStyle(
                      color: colors.textSecondary.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tagsState.requireValue.map((tag) {
                      final isSelected = selectedTagIds.contains(tag.id);
                      final tagColor = Color(
                        int.parse(tag.color.replaceFirst('#', '0xFF')),
                      );
                      return FilterChip(
                        label: Text(tag.name),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : tagColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: tagColor.withValues(alpha: 0.1),
                        selectedColor: tagColor,
                        selected: isSelected,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : tagColor.withValues(alpha: 0.3),
                          ),
                        ),
                        onSelected: (selected) {
                          final newSelected = List<String>.from(selectedTagIds);
                          if (selected) {
                            newSelected.add(tag.id);
                          } else {
                            newSelected.remove(tag.id);
                          }
                          taskVM.selectedTagIds.value = newSelected;
                        },
                      );
                    }).toList(),
                  ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
