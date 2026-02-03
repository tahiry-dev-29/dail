import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:flutter/material.dart';

class DividerBlock extends StatelessWidget {
  final BlockEntity block;

  const DividerBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: colors.border, thickness: 1),
    );
  }
}
