import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CalendarDayTile extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final bool hasTasks;
  final bool hasNotes;
  final VoidCallback onTap;

  const CalendarDayTile({
    super.key,
    required this.day,
    required this.onTap,
    this.isSelected = false,
    this.isToday = false,
    this.hasTasks = false,
    this.hasNotes = false,
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
        margin: const EdgeInsets.all(2), // Reduced margin for more space
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accent
              : (isToday ? todayBg : Colors.transparent),
          borderRadius: BorderRadius.circular(14), // More modern rounded corner
          border: isToday && !isSelected
              ? Border.all(
                  color: colors.accent.withValues(alpha: 0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$day",
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isToday ? colors.accent : textNorm),
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (hasTasks || hasNotes) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasTasks)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : colors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (hasTasks && hasNotes) const SizedBox(width: 2),
                      if (hasNotes)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white70
                                : colors.textSecondary.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
