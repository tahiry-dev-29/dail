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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              controller.toggleFavorite();
              onSave();
            },
            icon: Icon(
              fav ? Icons.star : Icons.star_border,
              color: fav ? Colors.amber : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
