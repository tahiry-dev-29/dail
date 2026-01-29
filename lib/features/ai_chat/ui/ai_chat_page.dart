import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../home/logic/home_signals.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textHint = isDark ? Colors.white38 : Colors.black38;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;
    final textFieldBg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);

    return Column(
      children: [
        // Chat Header (Custom for Page)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFF2563EB)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.robot,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gemini Assistant",
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        Divider(color: dividerColor, height: 1),

        // Chat History
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ChatBubble(
                message:
                    "Bonjour ! Je suis ton assistant DailyOS. Je peux créer, modifier ou déplacer tes tâches.",
                isAi: true,
                isDark: isDark,
              ),
            ],
          ),
        ),

        // Input Area
        Watch(
          (context) => Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              isNavBarVisible.value ? 110 : 20,
            ), // Dynamic bottom padding
            child: GlassContainer(
              borderRadius: 30,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: textFieldBg,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: textPrimary),
                      decoration: InputDecoration(
                        hintText: "Demandez à Gemini...",
                        hintStyle: TextStyle(color: textHint),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.paperPlane,
                      color: AppColors.aiColor,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isAi;
  final bool isDark;

  const _ChatBubble({
    required this.message,
    required this.isAi,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final aiBg = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final text = isDark || !isAi ? Colors.white : Colors.black87;

    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isAi ? aiBg : AppColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isAi ? Radius.zero : const Radius.circular(20),
            bottomRight: isAi ? const Radius.circular(20) : Radius.zero,
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: text, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }
}
