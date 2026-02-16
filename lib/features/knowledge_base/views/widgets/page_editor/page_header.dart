import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/page_editor/properties_toolbar.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/active_page_view_model.dart';
import 'package:daily_os/design_system/organisms/emoji_picker_modal.dart';
import 'package:flutter/material.dart';

/// PageHeader — surgical StatefulWidget for TextEditingController lifecycle.
class PageHeader extends StatefulWidget {
  final PageEntity page;

  const PageHeader({super.key, required this.page});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page.title);
  }

  @override
  void didUpdateWidget(covariant PageHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep controller in sync with page title if changed externally
    if (oldWidget.page.title != widget.page.title &&
        _titleController.text != widget.page.title) {
      _titleController.text = widget.page.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activePageVM = sl<ActivePageViewModel>();

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (widget.page.coverImageUrl != null)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.page.coverImageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          const SizedBox(height: 60),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Icon
              GestureDetector(
                onTap: () {
                  EmojiPickerModal.show(context, (emoji) {
                    activePageVM.updateIcon(emoji);
                  });
                },
                child: Hero(
                  tag: 'page-icon-${widget.page.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.page.iconEmoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Title Input
              TextField(
                controller: _titleController,
                onChanged: (value) {
                  activePageVM.updateTitle(value);
                },
                style: context.h1.copyWith(
                  color: colors.textPrimary,
                  fontWeight: .bold,
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
              PropertiesToolbar(page: widget.page),
              const SizedBox(height: 24),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
