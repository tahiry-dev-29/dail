import 'package:flutter/material.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.caption.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: context.colors.textSecondary,
      ),
    );
  }
}
