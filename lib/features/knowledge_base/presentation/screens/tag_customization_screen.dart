import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

class TagCustomizationScreen extends HookWidget {
  final TagEntity? tag; // Null means we're creating a new tag

  const TagCustomizationScreen({super.key, this.tag});

  static const List<String> _presetColors = [
    '#EF4444', // Red
    '#3B82F6', // Blue
    '#10B981', // Green
    '#F59E0B', // Amber
    '#8B5CF6', // Violet
    '#EC4899', // Pink
    '#06B6D4', // Cyan
    '#F97316', // Orange
    '#9CA3AF', // Grey
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagVM = sl<TagViewModel>();

    final nameController = useTextEditingController(text: tag?.name ?? '');
    final selectedColor = useState(tag?.color ?? _presetColors[0]);
    final selectedPriority = useState(tag?.priority ?? 0);

    void handleSave() {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      final newTag = TagEntity(
        id: tag?.id ?? const Uuid().v4(),
        name: name,
        color: selectedColor.value,
        priority: selectedPriority.value,
        createdAt: tag?.createdAt ?? DateTime.now(),
      );

      if (tag == null) {
        tagVM.createTag(newTag);
      } else {
        tagVM.updateTag(newTag);
      }
      Navigator.pop(context);
    }

    return GlassScaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(AppIcons.arrowLeft(context)),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  tag == null ? "Nouveau Tag" : "Modifier le Tag",
                  style: context.h2.copyWith(color: colors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Name Field
            Text(
              "NOM",
              style: context.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                style: context.bodyLarge.copyWith(color: colors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "Urgent, Personnel...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Color Selection
            Text(
              "COULEUR",
              style: context.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _presetColors.map((colorHex) {
                final isSelected = selectedColor.value == colorHex;
                final color = Color(
                  int.parse(colorHex.replaceFirst('#', '0xFF')),
                );

                return GestureDetector(
                  onTap: () => selectedColor.value = colorHex,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: colors.textPrimary, width: 3)
                          : null,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Priority Selection
            Text(
              "PRIORITÉ",
              style: context.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: List.generate(7, (index) {
                  final priority = index + 1;
                  final isSelected = selectedPriority.value == priority;

                  // Label based on Eisenhower/Custom logic
                  String label = priority.toString();
                  if (priority == 1) label = "P1 (Urgent)";
                  if (priority > 1 && priority <= 4) label = "P$priority";
                  if (priority == 5) label = "P5 (Pending)";
                  if (priority >= 6) label = "P$priority";

                  return GestureDetector(
                    onTap: () => selectedPriority.value = priority,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GlassCard(
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        color: isSelected
                            ? colors.accent.withValues(alpha: 0.2)
                            : null,
                        borderColor: isSelected ? colors.accent : null,
                        child: Text(
                          label,
                          style: context.bodySmall.copyWith(
                            color: isSelected
                                ? colors.accent
                                : colors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
