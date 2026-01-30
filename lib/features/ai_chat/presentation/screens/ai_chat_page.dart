import 'package:daily_os/design_system/atoms/app_colors.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                child: Icon(
                  AppIcons.robot(context),
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
                    style: context.bodyLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        AppIcons.solidCircle(context),
                        size: 8,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Online",
                        style: context.caption.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        Divider(color: colors.border, height: 1),

        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            borderRadius: 32,
            child: ListView(
              children: [
                _ChatBubble(
                  message:
                      "Bonjour ! Je suis ton assistant DailyOS. Je peux créer, modifier ou déplacer tes tâches.",
                  isAi: true,
                ),
              ],
            ),
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
            child: GlassCard(
              borderRadius: 30,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: context.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "Demandez à Gemini...",
                        hintStyle: context.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      AppIcons.send(context),
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

  const _ChatBubble({required this.message, required this.isAi});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final aiBg = colors.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final text = colors.isDark || !isAi ? Colors.white : Colors.black87;

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
          style: context.bodyMedium.copyWith(color: text, height: 1.4),
        ),
      ),
    );
  }
}
