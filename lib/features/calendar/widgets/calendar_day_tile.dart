import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textNorm = isDark ? Colors.white70 : Colors.black87;
    final todayBg = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : (isToday ? todayBg : Colors.transparent),
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
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
