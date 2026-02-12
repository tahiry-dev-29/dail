import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/active_page_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// SearchPage — surgical HookConsumerWidget for TextEditingController lifecycle.
class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchVM = sl<SearchViewModel>();
    final colors = context.colors;
    final activePageVM = sl<ActivePageViewModel>();
    final resultsState = searchVM.results.watch(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft(context), color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search pages...',
            hintStyle: context.bodyLarge.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            border: InputBorder.none,
          ),
          style: context.bodyLarge.copyWith(color: colors.textPrimary),
          onChanged: searchVM.search,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear, color: colors.textSecondary),
            onPressed: () {
              searchController.clear();
              searchVM.search('');
            },
          ),
        ],
      ),
      body: resultsState.map(
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 64,
                    color: colors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'Type to search...'
                        : 'No pages found',
                    style: context.bodyLarge.copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final page = results[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Hero(
                      tag: 'page-icon-${page.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          page.iconEmoji,
                          style: const TextStyle(fontSize: 24),
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          )
                        : null,
                    onTap: () {
                      activePageVM.setActivePageId(page.id);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
