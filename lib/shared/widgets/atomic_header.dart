import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/logic/home_signals.dart';
import 'glass_container.dart';
import 'package:intl/intl.dart';

class AtomicHeader extends StatelessWidget {
  const AtomicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMMM', 'fr_FR').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date & Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text(
                    'DAILYOS AI',
                    style: TextStyle(
                      color:
                          Colors.blueAccent, // approximation of text-blue-300
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red, // Notifications inactive
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Actions
          Row(
            children: [
              // Settings Button
              GestureDetector(
                onTap: () => isSettingsOpen.value = true,
                child: const GlassContainer(
                  borderRadius: 50,
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    FontAwesomeIcons.gear,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Progress Ring (Simulated)
              GestureDetector(
                onTap: () => triggerConfetti.value++,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    children: [
                      const Center(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            value: 0.0, // Initial 0%
                            backgroundColor: Colors.white12,
                            color: AppColors.accent,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "0%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
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
