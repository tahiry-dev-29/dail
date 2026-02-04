import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.textSecondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
