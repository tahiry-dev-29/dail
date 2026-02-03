import 'package:daily_os/features/knowledge_base/logic/active_page_state.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/knowledge_base_screen.dart';
import 'package:flutter/material.dart';

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
    // Set the active page when navigating via deep link
    activePageIdSignal.value = widget.pageId;
  }

  @override
  void didUpdateWidget(covariant PageEditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pageId != oldWidget.pageId) {
      activePageIdSignal.value = widget.pageId;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reuse the main layout
    return const KnowledgeBaseScreen();
  }
}
