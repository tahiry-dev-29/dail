import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = isAddTaskVisible.watch(context);
    final current = currentTab.watch(context);

    if (isVisible || current != AppTabs.planner.index) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: () => isAddTaskVisible.value = true,
      backgroundColor: context.colors.accent,
      foregroundColor: Colors.white,
      elevation: 8,
      child: Icon(AppIcons.add(context)),
    );
  }
}
