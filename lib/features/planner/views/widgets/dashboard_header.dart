import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/planner/views/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';

/// Dashboard header with folder icon, title, subtitle, and filter button.
class DashboardHeader extends StatelessWidget {
  final String title;
  final bool isFolder;

  const DashboardHeader({
    super.key,
    required this.title,
    this.isFolder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFolder ? Icons.folder_open_rounded : Icons.grid_view_rounded,
                size: 28,
                color: colors.accent,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.tune_rounded, color: colors.textSecondary),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FilterBottomSheet(),
                  );
                },
              ),
            ],
          ),
          if (isFolder)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Contenu du dossier',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
