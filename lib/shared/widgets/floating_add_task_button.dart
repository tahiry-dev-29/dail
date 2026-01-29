import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../features/home/logic/home_signals.dart';
import '../../features/planner/ui/widgets/add_task_inline.dart';

class FloatingAddTaskButton extends StatelessWidget {
  const FloatingAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = isAddTaskVisible.watch(context);
    final current = currentTab.watch(context);

    if (isVisible || current != AppTabs.planner.index) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => isAddTaskVisible.value = true,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.purple500, AppColors.blue500],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.purple500.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(FontAwesomeIcons.plus, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
