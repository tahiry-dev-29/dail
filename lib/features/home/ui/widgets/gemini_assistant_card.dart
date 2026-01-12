import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../core/theme/adaptive_colors.dart';

class GeminiAssistantCard extends StatelessWidget {
  const GeminiAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GlassContainer(
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
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.wandMagicSparkles,
                    color: Colors.blueAccent,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'GEMINI ASSISTANT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: colors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Message
          Text(
            '"Bonjour ! J\'ai analysé ton planning. Tu as une journée chargée. Veux-tu déplacer ta séance de sport ?"',
            style: TextStyle(
              fontSize: 15,
              color: colors.textPrimary,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          // CTA
          Row(
            children: [
              Text(
                'Appuyez pour discuter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                FontAwesomeIcons.arrowRight,
                size: 12,
                color: colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
