import 'package:daily_os/design_system/atoms/app_colors.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ChatOverlay extends StatelessWidget {
  const ChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isOpen = isChatOpen.watch(context);

    return AnimatedSlide(
      offset: isOpen ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        child: SafeArea(
          child: Column(
            children: [
              // Chat Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF9333EA), Color(0xFF2563EB)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppIcons.robot(context),
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gemini Core",
                              style: context.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  AppIcons.solidCircle(context),
                                  size: 6,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Online",
                                  style: context.caption.copyWith(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        AppIcons.close(context),
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => isChatOpen.value = false,
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),

              // Chat History
              const Expanded(child: ChatHistory()),

              // Input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassCard(
                  borderRadius: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: context.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Demandez à Gemini...",
                            hintStyle: context.bodyMedium.copyWith(
                              color: Colors.white38,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          AppIcons.send(context),
                          color: AppColors.blue500,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ChatBubble(
          message:
              "Bonjour ! Je suis ton assistant DailyOS. Je peux créer, modifier ou déplacer tes tâches.",
          isAi: true,
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
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isAi ? Colors.white.withValues(alpha: 0.1) : AppColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isAi ? Radius.zero : const Radius.circular(18),
            bottomRight: isAi ? const Radius.circular(18) : Radius.zero,
          ),
        ),
        child: Text(
          message,
          style: context.bodyMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
