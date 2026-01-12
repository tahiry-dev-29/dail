import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../task_edit_page.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../data/task_model.dart';
import '../../providers/task_provider.dart';
import '../../../../core/theme/adaptive_colors.dart';
import '../../../../shared/utils/toast_service.dart';
import '../../../../core/utils/app_icons.dart';

class TaskListItem extends ConsumerWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        opacity: task.isDone || task.isIgnored ? 0.55 : 1.0,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
          ),
          child: GlassContainer(
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
                    isIgnored: task.isIgnored,
                    accent: accent,
                    mutedIcon: mutedIcon,
                    onTap: () {
                      onToggle();
                      if (!task.isDone) {
                        ToastService.success(
                          context,
                          '✨ "${task.name}" terminée !',
                        );
                      } else {
                        ToastService.info(context, '"${task.name}" réactivée');
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone || task.isIgnored
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: mutedIcon,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Bottom Row: Time + Indicators
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Time Badge
                          _TimeBadge(
                            time: task.time,
                            isOverdue:
                                isOverdue && !task.isDone && !task.isIgnored,
                            accent: accent,
                          ),

                          // Deadline Badge
                          if (task.deadline != null)
                            _DeadlineBadge(deadline: task.deadline!),

                          // Indicators
                          if (task.description.isNotEmpty)
                            Icon(
                              FontAwesomeIcons.alignLeft,
                              size: 10,
                              color: mutedIcon.withValues(alpha: 0.5),
                            ),
                          if (task.subtasks.isNotEmpty)
                            _SubtaskIndicator(
                              done: task.subtasks.where((s) => s.isDone).length,
                              total: task.subtasks.length,
                              color: mutedIcon,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right: Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _ActionIcon(
                      icon: AppIcons.favorite(
                        context,
                        task.id == task.id ? task.isFavorite : false,
                      ), // Dummy equality to avoid lint if needed, but AppIcons.favorite is fine
                      color: task.isFavorite
                          ? Colors.redAccent
                          : mutedIcon.withValues(alpha: 0.4),
                      onTap: () {
                        ref.read(taskProvider.notifier).toggleFavorite(task.id);
                        if (!task.isFavorite) {
                          ToastService.success(context, '❤️ Coup de cœur !');
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    _ActionIcon(
                      icon: AppIcons.delete(context),
                      color: mutedIcon.withValues(alpha: 0.4),
                      onTap: () {
                        onDelete();
                        ToastService.error(context, '🗑️ Supprimée');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkOverdue(DateTime now) {
    if (task.date == null) return false;
    final taskDate = DateTime(
      task.date!.year,
      task.date!.month,
      task.date!.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    if (taskDate.isBefore(today)) return true;

    if (taskDate.isAtSameMomentAs(today)) {
      try {
        final parts = task.time.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final taskTime = DateTime(now.year, now.month, now.day, hour, minute);
          return taskTime.isBefore(now);
        }
      } catch (_) {}
    }
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
    final colors = context.colors;
    final warningColor = colors.isDark
        ? Colors.redAccent.withValues(alpha: 0.8)
        : Colors.red;

    return GestureDetector(
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
                      ? warningColor.withValues(alpha: 0.6)
                      : mutedIcon.withValues(alpha: 0.3)),
            width: 2,
          ),
          color: isDone ? accent : Colors.transparent,
        ),
        child: isDone
            ? Center(
                child: Icon(
                  AppIcons.check(context),
                  size: 10,
                  color: Colors.white,
                ),
              )
            : (isIgnored
                  ? Center(
                      child: Icon(
                        AppIcons.xmark(context),
                        size: 10,
                        color: warningColor,
                      ),
                    )
                  : null),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark
        ? Colors.redAccent.withValues(alpha: 0.8)
        : Colors.red;
    final color = isOverdue ? warningColor : accent;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orangeColor = isDark ? Colors.orangeAccent : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: orangeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.clock, size: 9, color: orangeColor),
          const SizedBox(width: 4),
          Text(
            DateFormat('HH:mm').format(deadline),
            style: TextStyle(
              color: orangeColor,
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

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }
}
