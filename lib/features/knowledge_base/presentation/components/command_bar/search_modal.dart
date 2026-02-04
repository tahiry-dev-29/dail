import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class SearchModal extends HookWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final searchVM = sl<SearchViewModel>();
    final activePageVM = sl<ActivePageViewModel>();
    final resultsState = searchVM.results.watch(context);
    final searchController = useTextEditingController();

    useEffect(() {
      return () {
        searchVM.clearSearch();
      };
    }, []);

    return Stack(
      children: [
        // Dismiss layer
        GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: const SizedBox.expand(),
        ),
        // Modal content
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: Material(
              color: Colors.transparent,
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search for pages...',
                          hintStyle: context.bodyLarge.copyWith(
                            color: colors.textSecondary.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            AppIcons.search(context),
                            color: colors.accent,
                          ),
                          border: InputBorder.none,
                        ),
                        style: context.bodyLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                        onChanged: searchVM.search,
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
                                    searchController.text.isEmpty
                                        ? 'Type to search...'
                                        : 'No pages found',
                                    style: context.bodyMedium.copyWith(
                                      color: colors.textSecondary,
                                    ),
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
                                  style: context.bodyMedium.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: page.preview.isNotEmpty
                                    ? Text(
                                        page.preview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.bodySmall.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  activePageVM.setActivePageId(page.id);
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
        ),
      ],
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
            style: context.bodySmall.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
