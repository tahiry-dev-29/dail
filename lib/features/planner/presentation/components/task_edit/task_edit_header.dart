import 'package:flutter/material.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/features/planner/presentation/providers/task_edit_controller.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassCard(
              borderRadius: 50,
              padding: const EdgeInsets.all(12),
              child: const Icon(
                FontAwesomeIcons.arrowLeft,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),

          Row(
            children: [
              // Favorite toggle
              GestureDetector(
                onTap: () => controller.toggleFavorite(),
                child: Builder(
                  builder: (context) {
                    final isFav = controller.isFavorite.watch(context);
                    return GlassCard(
                      borderRadius: 50,
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        isFav
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        size: 16,
                        color: isFav ? Colors.redAccent : Colors.white60,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Personnalise widgets button
              GestureDetector(
                onTap: () {
                  // TODO: Open widget customization
                },
                child: GlassCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.wandMagicSparkles,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Personnalise widgets',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
