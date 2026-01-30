import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActiveTimerCard extends StatelessWidget {
  const ActiveTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = colors.isDark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Scale font sizes based on width. 300 is a typical mobile width.
        final timeFontSize = (width / 4.5).clamp(40.0, 68.0);
        final msFontSize = (timeFontSize / 2.8).clamp(16.0, 24.0);
        final horizontalPadding = (width * 0.08).clamp(16.0, 24.0);

        return GlassCard(
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: horizontalPadding,
          ),
          borderRadius: 24,
          child: StreamBuilder(
            stream: Stream.periodic(const Duration(milliseconds: 16)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              final timeStr = DateFormat('HH:mm:ss').format(now);
              final msStr = (now.millisecond / 10).toInt().toString().padLeft(
                2,
                '0',
              );
              final dateStr = DateFormat(
                'EEEE d MMMM',
                'fr_FR',
              ).format(now).toUpperCase();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Display
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.calendar(context),
                          size: 12,
                          color: colors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateStr,
                          style: context.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Clock Display
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isDark
                          ? [Colors.white, Colors.lightBlueAccent]
                          : [const Color(0xFF1E293B), const Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            timeStr,
                            style: context.h1.copyWith(
                              fontSize: timeFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -1,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            '.$msStr',
                            style: context.bodyLarge.copyWith(
                              fontSize: msFontSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: -1,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Breathing status indicator
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(
                            alpha: 0.3 + (value * 0.7),
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.accent.withValues(
                                alpha: 0.2 * value,
                              ),
                              blurRadius: 10 * value,
                              spreadRadius: 2 * value,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
