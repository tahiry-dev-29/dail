import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/settings/logic/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ProToggleCard extends StatelessWidget {
  const ProToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPro = isDailyOsProEnabled.watch(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.isDark
              ? [
                  Colors.purple.withValues(alpha: 0.3),
                  Colors.blue.withValues(alpha: 0.2),
                ]
              : [
                  Colors.purple.withValues(alpha: 0.15),
                  Colors.blue.withValues(alpha: 0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withValues(alpha: colors.isDark ? 0.5 : 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FontAwesomeIcons.gem,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DailyOS Pro',
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  "Débloquez l'IA avancée",
                  style: context.caption.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: isPro,
            onChanged: (v) => isDailyOsProEnabled.value = v,
            activeTrackColor: colors.accent,
          ),
        ],
      ),
    );
  }
}
