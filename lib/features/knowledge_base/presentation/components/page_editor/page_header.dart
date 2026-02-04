import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/properties_toolbar.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/shared/widgets/emoji_picker_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageHeader extends HookWidget {
  final PageEntity page;

  const PageHeader({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activePageVM = sl<ActivePageViewModel>();
    final titleController = useTextEditingController(text: page.title);

    // Keep controller in sync with page title if changed externally
    useEffect(() {
      if (titleController.text != page.title) {
        titleController.text = page.title;
      }
      return null;
    }, [page.title]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (page.coverImageUrl != null)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(page.coverImageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          const SizedBox(height: 60),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              GestureDetector(
                onTap: () {
                  EmojiPickerModal.show(context, (emoji) {
                    activePageVM.updateIcon(emoji);
                  });
                },
                child: Hero(
                  tag: 'page-icon-${page.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      page.iconEmoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Title Input
              TextField(
                controller: titleController,
                onChanged: (value) {
                  activePageVM.updateTitle(value);
                },
                style: context.h1.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    color: colors.textSecondary.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              // Properties Toolbar
              PropertiesToolbar(page: page),
              const SizedBox(height: 24),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
