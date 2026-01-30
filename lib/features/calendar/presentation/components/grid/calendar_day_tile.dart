import 'package:flutter/material.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';

class CalendarDayTile extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDayTile({
    super.key,
    required this.day,
    required this.onTap,
    this.isSelected = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textNorm = colors.textSecondary;
    final todayBg = colors.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent
              : (isToday ? todayBg : Colors.transparent),
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: colors.accent, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            "$day",
            style: TextStyle(
              color: isSelected ? Colors.white : textNorm,
              fontWeight: isSelected || isToday
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
