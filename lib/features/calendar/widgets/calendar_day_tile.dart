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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : (isToday
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent),
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            "$day",
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
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
