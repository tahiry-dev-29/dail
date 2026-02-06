import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PageEditorScreen extends HookWidget {
  final String pageId;

  const PageEditorScreen({super.key, required this.pageId});

  @override
  Widget build(BuildContext context) {
    // Set the active page when navigating via deep link or when pageId changes
    useEffect(() {
      sl<ActivePageViewModel>().setActivePageId(pageId);
      return null;
    }, [pageId]);

    // Reuse the main layout
    // Use a standalone scaffold for deep linking
    return GlassScaffold(
      body:
          PageEditor(), // PageEditor uses activePageVM, so we don't pass ID directly if it doesn't take it
    );
  }
}
