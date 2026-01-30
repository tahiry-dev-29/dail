import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const TaskDetailsSection({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Watch signals
    final desc = controller.description.watch(context);
    final isExpanded = controller.isDescriptionExpanded.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.isDescriptionExpanded.value = !isExpanded,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Text('DESCRIPTION', style: context.caption),
              const Spacer(),
              Icon(
                isExpanded
                    ? AppIcons.chevronUp(context)
                    : AppIcons.chevronDown(context),
                size: 14,
                color: context.colors.textMuted,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? GlassCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: TextEditingController(
                      text: desc,
                    )..selection = TextSelection.collapsed(offset: desc.length),
                    onChanged: (val) => controller.description.value = val,
                    style: context.bodyMedium,
                    maxLines: 4,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: 'Add details, notes, or links...',
                      hintStyle: TextStyle(color: context.colors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterStyle: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
