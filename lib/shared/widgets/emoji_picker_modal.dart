import 'dart:ui';

import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmojiPickerModal extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerModal({super.key, required this.onEmojiSelected});

  // Curated list of premium/productivity emojis
  static const List<String> _emojis = [
    '📄',
    '📁',
    '📝',
    '📊',
    '📈',
    '📅',
    '✅',
    '🚀',
    '💡',
    '🔥',
    '⭐',
    '❤️',
    '🎨',
    '💻',
    '📱',
    '⌨️',
    '🔒',
    '🔑',
    '⚙️',
    '🛠️',
    '🏠',
    '🏢',
    '🎓',
    '📚',
    '🧠',
    '💼',
    '💰',
    '🛒',
    '🎁',
    '🎉',
    '🌍',
    '✈️',
    '🚗',
    '⏳',
    '⏰',
    '⚡',
    '🔋',
    '📷',
    '🎥',
    '🎧',
    '🎵',
    '🎮',
    '🍔',
    '🍕',
    '☕',
    '🍎',
    '🌱',
    '🌿',
    '☀️',
    '🌙',
    '🗑️',
    '⚠️',
    '❓',
    '💬',
    '📢',
    '🔔',
    '✨',
    '👋',
    '🤝',
    '🙌',
  ];

  static Future<void> show(BuildContext context, Function(String) onSelect) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Emoji Picker',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) =>
          EmojiPickerModal(onEmojiSelected: onSelect),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1.drive(Tween(begin: 0.95, end: 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        width: 320,
        height: 400,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Select Icon',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      final emoji = _emojis[index];
                      return GestureDetector(
                        onTap: () {
                          onEmojiSelected(emoji);
                          Navigator.pop(context);
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colors.border.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
