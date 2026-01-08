import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../shared/widgets/glass_container.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final daysInMonth = 31;
    final firstDayOffset = 4; // Start on Thursday etc.

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          GlassContainer(
            borderRadius: 30,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Month Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const Text(
                      "Janvier 2026",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Days Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                      .map(
                        (d) => Text(
                          d,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Calendar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: daysInMonth + firstDayOffset,
                  itemBuilder: (context, index) {
                    if (index < firstDayOffset) return const SizedBox.shrink();

                    final day = index - firstDayOffset + 1;
                    final isSelected = day == 4; // Mock selected
                    final hasTask = day == 4 || day == 5 || day == 12;

                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blueAccent
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "$day",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (hasTask)
                            Positioned(
                              bottom: 6,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.lightBlueAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
