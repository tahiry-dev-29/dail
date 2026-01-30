import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GeminiAssistantCard extends StatelessWidget {
  const GeminiAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24, // Matches reference rounded-3xl
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    AppIcons.assistant(context),
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'GEMINI ASSISTANT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: colors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Message
          Text(
            '"Bonjour ! J\'ai analysé ton planning. Tu as une journée chargée. Veux-tu déplacer ta séance de sport ?"',
            style: context.bodyMedium.copyWith(
              color: colors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          // CTA
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Appuyez pour discuter',
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  AppIcons.arrowRight(context),
                  size: 12,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
