import 'package:flutter/material.dart';
import '../../providers/task_edit_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TaskEditHeader extends StatelessWidget {
  final TaskEditController controller;
  final VoidCallback onSave;

  const TaskEditHeader({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Watch signals
    final fav = controller.isFavorite.watch(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: iconColor),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              controller.toggleFavorite();
              onSave();
            },
            icon: Icon(
              fav ? Icons.star : Icons.star_border,
              color: fav ? Colors.amber : iconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: iconColor),
          ),
        ],
      ),
    );
  }
}
