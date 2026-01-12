import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_edit_controller.dart';
import '../../../../core/theme/adaptive_colors.dart';

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
    final isExpanded = controller.isDetailsExpanded.watch(context);
    final description = controller.description.watch(context);

    final colors = context.colors;
    final textSecondary = colors.textSecondary;
    final textHint = colors.textSecondary.withValues(alpha: 0.5);
    final textInput = colors.textPrimary;

    Widget buildOptionItem({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool isActive = false,
      bool? isExpanded,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Icon(
                  icon,
                  size: 18,
                  color: isActive ? Colors.blueAccent : textSecondary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.blueAccent : textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (isExpanded != null)
                Icon(
                  isExpanded
                      ? FontAwesomeIcons.chevronDown
                      : FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: textHint,
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildOptionItem(
          icon: FontAwesomeIcons.barsStaggered,
          label: 'Add details',
          isActive: description.isNotEmpty,
          isExpanded: isExpanded,
          onTap: controller.toggleDetails,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 44, bottom: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: TextField(
                      controller: TextEditingController(text: description),
                      onChanged: (val) {
                        controller.updateDescription(val);
                        onSave();
                      },
                      maxLines: null,
                      minLines: 1,
                      style: TextStyle(color: textInput, fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tapez les détails ici...',
                        hintStyle: TextStyle(color: textHint),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
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
