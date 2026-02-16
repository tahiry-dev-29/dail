import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/views/screens/tag_customization_screen.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/tag_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TagManagerModal extends StatelessWidget {
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

    return GlassCard(
      borderRadius: 24,
      margin: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Gérer les Tags',
                style: context.h2.copyWith(fontWeight: .bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TagCustomizationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Créer un nouveau Tag'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 16),

          // List
          Expanded(
            child: tagsState.map(
              data: (tags) {
                if (tags.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun tag pour le moment',
                      style: context.bodyMedium.copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }

                // Sort by priority (asc)
                final sortedTags = tags.toList()
                  ..sort((a, b) => a.priority.compareTo(b.priority));

                return ListView.separated(
                  itemCount: sortedTags.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colors.border.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (context, index) {
                    final tag = sortedTags[index];
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
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: tagColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(
                        tag.name,
                        style: context.bodyMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: .w500,
                        ),
                      ),
                      subtitle: Text(
                        "Priorité: ${tag.priority}",
                        style: context.caption.copyWith(
                          color: colors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: .min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TagCustomizationScreen(tag: tag),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: colors.error,
                            ),
                            onPressed: () => tagVM.deleteTag(tag.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (e, _) => Center(child: Text('Erreur: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
