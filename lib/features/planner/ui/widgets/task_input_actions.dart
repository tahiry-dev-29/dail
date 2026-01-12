import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_input_provider.dart';
import '../../../../core/theme/adaptive_colors.dart';

class TaskInputActions extends StatelessWidget {
  final TaskInputState state;

  const TaskInputActions({super.key, required this.state});

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && context.mounted) {
      final newTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      state.time.value = newTime;
    }
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && context.mounted) {
        state.deadline.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = state.time.watch(context);
    final selectedDeadline = state.deadline.watch(context);
    final fav = state.isFavorite.watch(context);
    final isDescExpanded = state.isDescriptionExpanded.watch(context);

    final colors = context.colors;
    final hasTime = selectedTime != '00:00';

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        // Description toggle
        _ActionButton(
          icon: FontAwesomeIcons.bars,
          isActive: isDescExpanded,
          colors: colors,
          onTap: () => state.isDescriptionExpanded.value = !isDescExpanded,
          tooltip: 'Description',
        ),
        // Time
        _ActionButton(
          icon: FontAwesomeIcons.clock,
          isActive: hasTime,
          label: hasTime ? selectedTime : null,
          colors: colors,
          onTap: () => _pickTime(context),
          tooltip: 'Heure',
        ),
        // Deadline
        _ActionButton(
          icon: FontAwesomeIcons.calendarCheck,
          isActive: selectedDeadline != null,
          label: selectedDeadline != null
              ? DateFormat('dd/MM').format(selectedDeadline)
              : null,
          colors: colors,
          onTap: () => _pickDeadline(context),
          tooltip: 'Deadline',
        ),
        // Favorite
        _ActionButton(
          icon: fav ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          isActive: fav,
          activeColorOverride: Colors.redAccent,
          colors: colors,
          onTap: () => state.isFavorite.value = !fav,
          tooltip: 'Favori',
        ),
      ],
    );
  }
}

/// Action Button with proper touch target (44px minimum for mobile UX)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final String? label;
  final AdaptiveColors colors;
  final VoidCallback onTap;
  final String tooltip;
  final Color? activeColorOverride;

  const _ActionButton({
    required this.icon,
    required this.isActive,
    required this.colors,
    required this.onTap,
    required this.tooltip,
    this.label,
    this.activeColorOverride,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColorOverride ?? colors.accent;
    final inactiveColor = colors.textSecondary.withValues(alpha: 0.5);
    final displayColor = isActive ? effectiveActiveColor : inactiveColor;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // Minimum 44px touch target (Apple HIG recommendation)
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? displayColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? displayColor.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: displayColor),
                if (label != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    label!,
                    style: TextStyle(
                      color: displayColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
