import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/ai_chat/presentation/state/ai_chat_view_model.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AiChatPage extends HookWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chatVM = sl<AiChatViewModel>();
    final messages = chatVM.messages.watch(context);
    final isTyping = chatVM.isTyping.watch(context);
    final textController = useTextEditingController();
    final scrollController = useScrollController();

    // Auto-scroll to bottom on new messages
    useEffect(() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      return null;
    }, [messages.length, isTyping]);

    void handleSend() {
      final text = textController.text.trim();
      if (text.isNotEmpty) {
        chatVM.sendMessage(text);
        textController.clear();
      }
    }

    return Column(
      children: [
        // Chat Header (Custom for Page)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors.ai, colors.accent]),
                  shape: .circle,
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
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < messages.length) {
                  final msg = messages[index];
                  return _ChatBubble(message: msg.text, isAi: !msg.isUser);
                } else {
                  return const _TypingIndicator();
                }
              },
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
              sl<HomeViewModel>().isNavBarVisible.value
                  ? 100
                  : 20, // Reduced from 110 to 100
            ),
            child: GlassCard(
              borderRadius: 30,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: context.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                      onSubmitted: (_) => handleSend(),
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
                      color: colors.ai,
                      size: 18,
                    ),
                    onPressed: handleSend,
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
          color: isAi ? aiBg : colors.accent,
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

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 24),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
