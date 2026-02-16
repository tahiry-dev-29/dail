import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/page_editor/page_editor.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/active_page_view_model.dart';
import 'package:flutter/material.dart';

/// Deep-link entry for PageEditor.
/// Sets activePageId on mount / pageId change via StatefulWidget lifecycle.
class PageEditorScreen extends StatefulWidget {
  final String pageId;

  const PageEditorScreen({super.key, required this.pageId});

  @override
  State<PageEditorScreen> createState() => _PageEditorScreenState();
}

class _PageEditorScreenState extends State<PageEditorScreen> {
  @override
  void initState() {
    super.initState();
    sl<ActivePageViewModel>().setActivePageId(widget.pageId);
  }

  @override
  void didUpdateWidget(covariant PageEditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId) {
      sl<ActivePageViewModel>().setActivePageId(widget.pageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(body: PageEditor());
  }
}
