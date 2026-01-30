import 'package:flutter/material.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/features/planner/logic/task_edit_controller.dart';

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
              const Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.white30,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      hintText: 'Add details, notes, or links...',
                      hintStyle: TextStyle(color: Colors.white30),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterStyle: TextStyle(
                        color: Colors.white24,
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
