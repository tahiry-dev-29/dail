import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor.dart';
import 'package:flutter/material.dart';

class PageEditorModal extends StatelessWidget {
  const PageEditorModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const PageEditorModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      insetPadding: isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionIcon(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
            // Editor Content
            const Expanded(child: PageEditor()),
          ],
        ),
      ),
    );
  }
}
