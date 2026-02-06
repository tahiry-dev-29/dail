import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageTitleIconEditorModal extends HookWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleController = useTextEditingController(text: page.title);
    final selectedEmoji = useState(page.iconEmoji);

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Page',
              style: context.h2.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
                      selectedEmoji.value,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: titleController,
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
            const Text(
              'Choose Icon',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emojis
                  .map(
                    (e) => GestureDetector(
                      onTap: () => selectedEmoji.value = e,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedEmoji.value == e
                              ? colors.accent.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedEmoji.value == e
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
                // We use the existing update logic via VM if it's the active page or via specialized usecase/vm method
                // For simplicity here, we assume the VM can handle generic page updates or we add a method
                await sl<ActivePageViewModel>().setActivePageId(page.id);
                await sl<ActivePageViewModel>().updateTitle(
                  titleController.text.trim(),
                );
                await sl<ActivePageViewModel>().updateIcon(selectedEmoji.value);

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
