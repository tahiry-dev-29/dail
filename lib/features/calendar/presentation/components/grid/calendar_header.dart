import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/calendar/presentation/state/calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;

  const CalendarHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final contentColor = colors.textPrimary;
    final calendarVM = sl<CalendarViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat(
                'MMMM yyyy',
                'fr_FR',
              ).format(currentMonth).toUpperCase(),
              style: AppTypography.h2.copyWith(
                color: contentColor,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Row(
            children: [
              _buildNavButton(
                context,
                icon: Icons.chevron_left_rounded,
                onPressed: () => calendarVM.prevMonth(),
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                context,
                icon: Icons.chevron_right_rounded,
                onPressed: () => calendarVM.nextMonth(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final colors = context.colors;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colors.accent, size: 20),
      ),
    );
  }
}
