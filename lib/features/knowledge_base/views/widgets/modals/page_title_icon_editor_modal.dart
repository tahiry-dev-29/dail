import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/active_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Surgical StatefulWidget for TextEditingController lifecycle.
class PageTitleIconEditorModal extends StatefulWidget {
  final PageEntity page;

  const PageTitleIconEditorModal({super.key, required this.page});

  static Future<void> show(BuildContext context, PageEntity page) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PageTitleIconEditorModal(page: page),
    );
  }

  @override
  State<PageTitleIconEditorModal> createState() =>
      _PageTitleIconEditorModalState();
}

class _PageTitleIconEditorModalState extends State<PageTitleIconEditorModal> {
  late final TextEditingController _titleController;
  late final Signal<String> _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page.title);
    _selectedEmoji = signal(widget.page.iconEmoji);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedEmoji = _selectedEmoji.watch(context);

    final emojis = ['📄', '📝', '📓', '📁', '💡', '🚀', '⭐', '🔥', '✅', '🏗️'];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Text(
              'Edit Page',
              style: context.h2.copyWith(fontWeight: .bold),
              textAlign: .center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Quick emoji picker grid implementation
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Text(
                      selectedEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Page title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: context.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Choose Icon', style: TextStyle(fontWeight: .bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emojis
                  .map(
                    (e) => GestureDetector(
                      onTap: () => _selectedEmoji.value = e,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedEmoji == e
                              ? colors.accent.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedEmoji == e
                                ? colors.accent
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () async {
                await sl<ActivePageViewModel>().setActivePageId(widget.page.id);
                await sl<ActivePageViewModel>().updateTitle(
                  _titleController.text.trim(),
                );
                await sl<ActivePageViewModel>().updateIcon(
                  _selectedEmoji.value,
                );

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
