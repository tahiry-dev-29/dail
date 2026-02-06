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

class SearchPage extends HookWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final searchVM = sl<SearchViewModel>();
    final activePageVM = sl<ActivePageViewModel>();
    final resultsState = searchVM.results.watch(context);
    final searchController = useTextEditingController(
      text: searchVM.query.value,
    );

    // Initial search if query is already present
    useEffect(() {
      if (searchController.text.isNotEmpty) {
        searchVM.search(searchController.text);
      }
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: colors.isDark
              ? Colors.black
              : Colors.white.withValues(alpha: 0.1),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Search App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Subtle gradient for depth
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.accent.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Recherche',
                    style: AppTypography.h2.copyWith(color: colors.textPrimary),
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.fromLTRB(56, 40, 0, 16),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colors.textPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Search Input Box
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  borderRadius: 20,
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    onChanged: (val) => searchVM.search(val),
                    style: context.bodyLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Rechercher une page...',
                      hintStyle: context.bodyLarge.copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.4),
                      ),
                      prefixIcon: Icon(
                        AppIcons.search(context),
                        color: colors.accent,
                        size: 22,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: colors.textSecondary,
                                size: 18,
                              ),
                              onPressed: () {
                                searchController.clear();
                                searchVM.clearSearch();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),

            // Results State
            resultsState.map(
              data: (results) {
                if (results.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(
                      context,
                      searchController.text.isEmpty,
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final page = results[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          borderRadius: 16,
                          child: ListTile(
                            onTap: () {
                              activePageVM.setActivePageId(page.id);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Hero(
                              tag: 'page-icon-${page.id}',
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  page.iconEmoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            title: Text(
                              page.title,
                              style: context.bodyLarge.copyWith(
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
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Erreur: $e',
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isInitial) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isInitial ? Icons.search_rounded : Icons.search_off_rounded,
            size: 64,
            color: colors.textSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            isInitial
                ? 'Commencez à taper pour rechercher'
                : 'Aucun résultat trouvé',
            style: context.bodyMedium.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
