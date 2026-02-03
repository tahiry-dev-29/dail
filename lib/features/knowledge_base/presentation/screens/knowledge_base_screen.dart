import 'package:daily_os/features/knowledge_base/presentation/components/page_editor/page_editor.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

class KnowledgeBaseScreen extends StatelessWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(width: 250, child: KnowledgeBaseSidebar()),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                // Knowledge Base Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Knowledge Base',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: const PageEditor()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
