import 'package:daily_os/design_system/atoms/action_icon.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/domain/entities/task_entity.dart';
import 'package:daily_os/features/planner/presentation/screens/task_edit_page.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onFavorite;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textPrimary = colors.textPrimary;
    final mutedIcon = colors.textSecondary;
    final accent = colors.accent;

    // Check if task is overdue for visual warning
    final now = DateTime.now();
    final isOverdue = _checkOverdue(now);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Opacity(
        opacity: task.isDone ? 0.55 : 1.0,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
          ),
          child: GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Check Circle
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _CheckCircle(
                    isDone: task.isDone,
                    isIgnored: false,
                    accent: accent,
                    mutedIcon: mutedIcon,
                    onTap: () {
                      onToggle();
                      if (!task.isDone) {
                        ToastService.success(
                          context,
                          '✨ "${task.name}" terminée !',
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Center: Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Name
                      Text(
                        task.name,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: mutedIcon,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Bottom Row: Time + Indicators + Actions
                      Row(
                        children: [
                          // Time Badge
                          if (task.time.isNotEmpty && task.time != '00:00')
                            _TimeBadge(
                              time: task.time,
                              isOverdue: isOverdue && !task.isDone,
                              accent: accent,
                            ),

                          // Deadline Badge
                          if (task.deadline != null) ...[
                            const SizedBox(width: 6),
                            _DeadlineBadge(deadline: task.deadline!),
                          ],

                          // Indicators
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Icon(
                              FontAwesomeIcons.alignLeft,
                              size: 10,
                              color: mutedIcon.withValues(alpha: 0.5),
                            ),
                          ],
                          if (task.subtasks.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _SubtaskIndicator(
                              done: task.subtasks.where((s) => s.isDone).length,
                              total: task.subtasks.length,
                              color: mutedIcon,
                            ),
                          ],

                          const Spacer(),

                          // Action Icons (Right side)
                          ActionIcon(
                            icon: task.isFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: task.isFavorite
                                ? Colors.redAccent
                                : mutedIcon.withValues(alpha: 0.4),
                            onTap: onFavorite ?? () {},
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 8),
                          ActionIcon(
                            icon: FontAwesomeIcons.trash,
                            color: mutedIcon.withValues(alpha: 0.4),
                            onTap: () {
                              onDelete();
                              ToastService.error(context, '🗑️ Supprimée');
                            },
                            padding: const EdgeInsets.all(4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkOverdue(DateTime now) {
    // Basic overdue logic, assuming date match via planner
    if (task.deadline != null && task.deadline!.isBefore(now)) return true;

    // Parse time string if needed?
    return false;
  }
}

// --- Micro Widgets ---

class _CheckCircle extends StatelessWidget {
  final bool isDone;
  final bool isIgnored;
  final Color accent;
  final Color mutedIcon;
  final VoidCallback onTap;

  const _CheckCircle({
    required this.isDone,
    required this.isIgnored,
    required this.accent,
    required this.mutedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone
                  ? accent
                  : (isIgnored
                        ? Colors.red.withValues(alpha: 0.6)
                        : mutedIcon.withValues(alpha: 0.3)),
              width: 2,
            ),
            color: isDone ? accent : Colors.transparent,
          ),
          child: isDone
              ? const Center(
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                )
              : (isIgnored
                    ? const Center(
                        child: Icon(
                          FontAwesomeIcons.xmark,
                          size: 10,
                          color: Colors.red,
                        ),
                      )
                    : null),
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  final String time;
  final bool isOverdue;
  final Color accent;

  const _TimeBadge({
    required this.time,
    required this.isOverdue,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = isOverdue ? Colors.red : accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  final DateTime deadline;

  const _DeadlineBadge({required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FontAwesomeIcons.clock, size: 9, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            DateFormat('HH:mm').format(deadline),
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtaskIndicator extends StatelessWidget {
  final int done;
  final int total;
  final Color color;

  const _SubtaskIndicator({
    required this.done,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          FontAwesomeIcons.listCheck,
          size: 10,
          color: color.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 3),
        Text(
          '$done/$total',
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
