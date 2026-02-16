import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:flutter/material.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        final homeVM = sl<HomeViewModel>();
        homeVM.isChatOpen.value = !homeVM.isChatOpen.value;
      },
      child: Stack(
        children: [
          // Glow effect only if dark mode or desired
          if (colors.isDark)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colors.ai.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: colors.ai.withValues(alpha: 0.3),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

          GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colors.ai, colors.accent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      AppIcons.assistant(context),
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GEMINI ASSISTANT',
                        style: context.caption.copyWith(
                          color: colors.ai,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"Bonjour ! J\'ai analysé ton planning. Tu as une journée chargée. Veux-tu déplacer ta séance de sport ?"',
                        style: context.bodyMedium.copyWith(
                          color: colors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Appuyez pour discuter...',
                        style: context.caption.copyWith(
                          color: colors.textSecondary.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
