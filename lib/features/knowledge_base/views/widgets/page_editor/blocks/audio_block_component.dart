import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/block_view_model.dart';
import 'package:daily_os/shared/widgets/audio_recorder_widget.dart';
import 'package:flutter/material.dart';

/// AudioBlockComponent — Delegating to shared AudioRecorderWidget
class AudioBlockComponent extends StatelessWidget {
  final BlockEntity block;

  const AudioBlockComponent({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final audioPath = block.content['audioPath'] as String?;
    final duration = block.content['duration'] != null
        ? (block.content['duration'] as int) * 1000
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.customSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AudioRecorderWidget(
        audioPath: audioPath,
        audioDurationMs: duration,
        onSaved: (path, durationMs) {
          sl<BlockViewModel>().updateBlock(
            block.copyWith(
              content: {
                ...block.content,
                'audioPath': path,
                'duration': (durationMs ?? 0) ~/ 1000,
              },
            ),
          );
        },
        onDelete: () {
          final newContent = Map<String, dynamic>.from(block.content)
            ..remove('audioPath')
            ..remove('duration');
          sl<BlockViewModel>().updateBlock(block.copyWith(content: newContent));
        },
      ),
    );
  }
}
