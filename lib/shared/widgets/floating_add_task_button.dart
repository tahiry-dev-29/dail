import 'package:flutter/material.dart';
import 'package:daily_os/design_system/molecules/buttons/primary_circle_button.dart';
import 'package:daily_os/features/home/presentation/providers/home_signals.dart';
import 'package:daily_os/features/planner/presentation/components/task_form/add_task_inline.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = isAddTaskVisible.watch(context);
    final current = currentTab.watch(context);

    if (isVisible || current != AppTabs.planner.index) {
      return const SizedBox.shrink();
    }

    return PrimaryCircleButton(
      icon: FontAwesomeIcons.plus,
      onTap: () => isAddTaskVisible.value = true,
    );
  }
}
