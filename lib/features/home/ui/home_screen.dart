import 'dart:async';
import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_container.dart';
import 'widgets/ai_insight_card.dart';
import 'widgets/stats_grid.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  String _timeStr = "00:00";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _timeStr = DateFormat('HH:mm').format(DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AI Insight
          const AiInsightCard(),
          const SizedBox(height: 20),

          // Next Task / Current Action
          GlassContainer(
            borderRadius: 25,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  "EN COURS MAINTENANT",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Deep Work", // Placeholder until connected to Provider
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timeStr,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 40,
                    fontFamily: 'monospace', // Use Monospace for clock
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats
          const StatsGrid(doneCount: 3, remainingCount: 5), // Placeholders

          const SizedBox(height: 100), // Space for specific bottom padding
        ],
      ),
    );
  }
}
