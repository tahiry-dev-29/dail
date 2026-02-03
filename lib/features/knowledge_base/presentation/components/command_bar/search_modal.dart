import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/logic/active_page_controller.dart';
import 'package:daily_os/features/knowledge_base/logic/search_controller.dart'
    as kb;
import 'package:daily_os/features/knowledge_base/logic/search_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => const SearchModal(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1.drive(Tween(begin: 0.95, end: 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    kb.SearchController.clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resultsState = searchResultsSignal.watch(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.symmetric(vertical: 80),
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: .min,
              children: [
                // Top Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search for pages...',
                      hintStyle: TextStyle(color: colors.textSecondary),
                      prefixIcon: Icon(Icons.search, color: colors.accent),
                      border: .none,
                    ),
                    style: TextStyle(color: colors.textPrimary, fontSize: 18),
                    onChanged: kb.SearchController.search,
                  ),
                ),
                const Divider(height: 1),

                // Results Area
                Flexible(
                  child: resultsState.map(
                    data: (results) {
                      if (results.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_outlined,
                                size: 48,
                                color: colors.textSecondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Type to search...'
                                    : 'No pages found',
                                style: TextStyle(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final page = results[index];
                          return ListTile(
                            leading: Hero(
                              tag: 'page-icon-${page.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  page.iconEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            title: Text(
                              page.title,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: .w500,
                              ),
                            ),
                            subtitle: page.preview.isNotEmpty
                                ? Text(
                                    page.preview,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: colors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              ActivePageController.selectPage(page.id);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    error: (e, _) => Center(child: Text('Error: $e')),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

                const Divider(height: 1),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      _buildShortcutHint(context, 'ESC', 'to close'),
                      const SizedBox(width: 16),
                      _buildShortcutHint(context, 'ENTER', 'to open'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutHint(BuildContext context, String key, String label) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: colors.border),
          ),
          child: Text(
            key,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 10,
              fontWeight: .bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: colors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}
