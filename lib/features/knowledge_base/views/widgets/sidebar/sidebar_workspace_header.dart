import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/workspace_entity.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/workspace_switcher_modal.dart';
import 'package:flutter/material.dart';

class SidebarWorkspaceHeader extends StatelessWidget {
  final WorkspaceEntity? activeWorkspace;

  const SidebarWorkspaceHeader({super.key, required this.activeWorkspace});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      bottom: false,
      child: InkWell(
        onTap: () => WorkspaceSwitcherModal.show(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.surface,
                child: Icon(
                  Icons.person,
                  color: colors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          activeWorkspace?.name ?? 'Personal Workspace',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
