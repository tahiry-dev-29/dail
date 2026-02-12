import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/tag_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/shared/widgets/atomic_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:uuid/uuid.dart';

/// Surgical StatefulWidget for TextEditingController lifecycle.
class TagCustomizationScreen extends StatefulWidget {
  final TagEntity? tag;

  const TagCustomizationScreen({super.key, this.tag});

  @override
  State<TagCustomizationScreen> createState() => _TagCustomizationScreenState();
}

class _TagCustomizationScreenState extends State<TagCustomizationScreen> {
  late final TextEditingController _nameController;
  late final Signal<Color> _selectedColor;
  late final Signal<int> _priority;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag?.name ?? '');

    // Parse initial color
    Color initialColor = Colors.blue;
    if (widget.tag != null) {
      try {
        final hex = widget.tag!.color.replaceFirst('#', '');
        initialColor = Color(int.parse(hex, radix: 16) + 0xFF000000);
      } catch (_) {}
    }
    _selectedColor = signal(initialColor);
    _priority = signal(widget.tag?.priority ?? 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedColor = _selectedColor.watch(context);
    final priority = _priority.watch(context);

    return GlassScaffold(
      appBar: AppBar(
        title: Text(
          widget.tag != null ? 'Edit Tag' : 'New Tag',
          style: context.h2.copyWith(
            color: colors.textPrimary,
            fontWeight: .bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft(context), color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton(onPressed: _saveTag, child: const Text('Save')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Preview
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selectedColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selectedColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _nameController.text.isEmpty
                          ? 'Tag Name'
                          : _nameController.text,
                      style: context.bodyMedium.copyWith(
                        color: selectedColor,
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name
            Text(
              'Tag Name',
              style: context.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: .w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: widget.tag == null,
              decoration: InputDecoration(
                hintText: 'e.g. Design, Dev, Research...',
                hintStyle: TextStyle(
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                filled: true,
                fillColor: colors.surfaceElevated,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Color Picker
            Text(
              'Color',
              style: context.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: .w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            AtomicColorPicker(
              initialColor: selectedColor,
              onColorChanged: (c) => _selectedColor.value = c,
            ),
            const SizedBox(height: 24),

            // Priority
            Text(
              'Priority',
              style: context.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: .w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Slider(
                  value: priority.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) => _priority.value = v.toInt(),
                  activeColor: selectedColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '$priority',
                  style: context.bodyLarge.copyWith(fontWeight: .bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveTag() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final colorHex =
        '#${_selectedColor.peek().toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    final tagVM = sl<TagViewModel>();
    if (widget.tag != null) {
      tagVM.updateTag(
        widget.tag!.copyWith(
          name: name,
          color: colorHex,
          priority: _priority.peek(),
        ),
      );
    } else {
      tagVM.createTag(
        TagEntity(
          id: const Uuid().v4(),
          name: name,
          color: colorHex,
          priority: _priority.peek(),
          createdAt: DateTime.now(),
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
