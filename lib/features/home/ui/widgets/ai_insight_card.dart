import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/home_signals.dart';
import '../../../../shared/widgets/glass_container.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isChatOpen.value = !isChatOpen.value,
      child: Stack(
        children: [
          // Glow effect
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.purple500, AppColors.blue500],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GEMINI ASSISTANT',
                        style: TextStyle(
                          color: Color(0xFFD8B4FE), // purple-300
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '"Bonjour ! J\'ai analysé ton planning. Tu as une journée chargée. Veux-tu déplacer ta séance de sport ?"',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Appuyez pour discuter...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
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
