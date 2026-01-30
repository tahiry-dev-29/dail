import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlannerHeader extends ConsumerWidget {
  const PlannerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Timeline', style: context.h2),
          GlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: ActionIcon(
              icon: AppIcons.refresh(context),
              onTap: () => ref.read(taskListProvider.notifier).loadTasks(),
              color: context.colors.textSecondary,
              size: 14,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
