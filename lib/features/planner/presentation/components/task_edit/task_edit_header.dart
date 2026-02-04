import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/presentation/state/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskEditHeader extends StatelessWidget {
  final TaskEditViewModel viewModel;
  final VoidCallback onSave;

  const TaskEditHeader({
    super.key,
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: ActionIcon(
              icon: AppIcons.arrowLeft(context),
              onTap: () => Navigator.pop(context),
              color: context.colors.textPrimary,
              size: 18,
              padding: const EdgeInsets.all(16),
            ),
          ),

          Row(
            children: [
              // Favorite toggle
              Watch((context) {
                final isFav = viewModel.isFavorite.watch(context);
                return GlassCard(
                  borderRadius: 50,
                  padding: EdgeInsets.zero,
                  child: ActionIcon(
                    icon: AppIcons.favorite(context, isFav),
                    onTap: () => viewModel.toggleFavorite(),
                    color: isFav
                        ? Colors.redAccent
                        : context.colors.textSecondary,
                    size: 18,
                    padding: const EdgeInsets.all(16),
                  ),
                );
              }),
              const SizedBox(width: 12),
              // Personnalise widgets button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Widget customization coming soon!',
                          style: TextStyle(color: context.colors.textOnAccent),
                        ),
                        backgroundColor: context.colors.accent,
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          AppIcons.assistant(context),
                          size: 14,
                          color: context.colors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Personnalise widgets',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
