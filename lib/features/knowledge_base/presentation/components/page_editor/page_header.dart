import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_controller.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatefulWidget {
  final PageEntity page;

  const PageHeader({super.key, required this.page});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page.title);
  }

  @override
  void didUpdateWidget(covariant PageHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.title != widget.page.title &&
        _titleController.text != widget.page.title) {
      // Only update if external change and not currently editing (basic optimistic check)
      // Real bidirectional sync might need more complex cursor handling
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

    return Column(
      crossAxisAlignment: .start,
      children: [
        // Cover Image Area (Placeholder for now, or actual image if url exists)
        // Figma-like: Hover to show "Add Cover" if null.
        if (widget.page.coverImageUrl != null)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.page.coverImageUrl!),
                fit: .cover,
              ),
            ),
            // TODO: Add "Change Cover" / "Remove" buttons on hover
          )
        else
          // Minimal spacing or "Add Cover" button area
          const SizedBox(height: 60), // Top spacing matching Notion

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ), // Editor padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              GestureDetector(
                onTap: () {
                  // TODO: Open Emoji Picker
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
                  // Debounce could be added here in Controller,
                  // but for local state immediate update is fine,
                  // Logic layer should handle persistence throttling.
                  ActivePageController.updateTitle(value);
                },
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: .bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    color: colors.textSecondary.withValues(alpha: 0.5),
                  ),
                  border: .none,
                  contentPadding: .zero,
                  isDense: true,
                ),
                maxLines: null,
                keyboardType: .multiline,
              ),
              // Metadata properties (tags, date, etc.) could go here
              const SizedBox(height: 24),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
