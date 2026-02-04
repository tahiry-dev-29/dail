import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeNextTaskWidget extends StatelessWidget {
  final String currentTaskName;

  const HomeNextTaskWidget({super.key, required this.currentTaskName});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final timeStr = sl<HomeViewModel>().timeString.watch(context);

    return GlassCard(
      borderRadius: 25,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "EN COURS MAINTENANT",
            style: context.caption.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentTaskName,
            style: context.h1.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: context.h1.copyWith(
              color: Colors.blueAccent,
              fontSize: 40,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
