import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = sl<HomeViewModel>();
    final isVisible = homeVM.isAddTaskVisible.watch(context);
    final current = homeVM.currentTab.watch(context);

    if (isVisible || current != AppTabs.workspace.index) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: () => homeVM.isAddTaskVisible.value = true,
      backgroundColor: context.colors.accent,
      foregroundColor: Colors.white,
      elevation: 8,
      child: Icon(AppIcons.add(context)),
    );
  }
}
