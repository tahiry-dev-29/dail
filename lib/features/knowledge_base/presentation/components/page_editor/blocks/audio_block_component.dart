import 'dart:async';

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// AudioBlockComponent — surgical StatefulWidget for stream subscriptions
/// and AudioRecorder/Player lifecycle.
class AudioBlockComponent extends StatefulWidget {
  final BlockEntity block;

  const AudioBlockComponent({super.key, required this.block});

  @override
  State<AudioBlockComponent> createState() => _AudioBlockComponentState();
}

class _AudioBlockComponentState extends State<AudioBlockComponent> {
  // Signals for UI state
  final _isRecording = signal(false);
  final _isPlaying = signal(false);
  final _recordingDuration = signal(Duration.zero);
  final _playbackPosition = signal(Duration.zero);
  final _totalDuration = signal(Duration.zero);

  Timer? _recordingTimer;

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRecording = _isRecording.watch(context);
    final isPlaying = _isPlaying.watch(context);
    final recordingDuration = _recordingDuration.watch(context);
    final playbackPosition = _playbackPosition.watch(context);
    final totalDuration = _totalDuration.watch(context);

    final hasAudio = widget.block.content['audioPath'] != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.customSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecording
              ? colors.error.withValues(alpha: 0.5)
              : colors.border.withValues(alpha: 0.3),
        ),
      ),
      child: hasAudio && !isRecording
          ? _buildPlaybackUI(
              context,
              isPlaying,
              playbackPosition,
              totalDuration,
            )
          : _buildRecordUI(context, isRecording, recordingDuration),
    );
  }

  Widget _buildRecordUI(
    BuildContext context,
    bool isRecording,
    Duration elapsed,
  ) {
    final colors = context.colors;
    return Row(
      children: [
        // Record Button
        GestureDetector(
          onTap: () {
            if (isRecording) {
              _stopRecording();
            } else {
              _startRecording();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isRecording
                  ? colors.error
                  : colors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: isRecording ? Colors.white : colors.error,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                isRecording ? 'Recording...' : 'Tap to record audio',
                style: context.bodyMedium.copyWith(
                  color: isRecording ? colors.error : colors.textSecondary,
                  fontWeight: isRecording ? .bold : .normal,
                ),
              ),
              if (isRecording)
                Text(
                  _formatDuration(elapsed),
                  style: context.bodySmall.copyWith(
                    color: colors.error.withValues(alpha: 0.7),
                    fontFamily: 'monospace',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackUI(
    BuildContext context,
    bool isPlaying,
    Duration position,
    Duration total,
  ) {
    final colors = context.colors;

    return Row(
      children: [
        // Play/Pause Button
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              _pausePlayback();
            } else {
              _startPlayback();
            }
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: colors.accent,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: total.inMilliseconds > 0
                    ? position.inMilliseconds / total.inMilliseconds
                    : 0.0,
                backgroundColor: colors.border.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(colors.accent),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: context.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    _formatDuration(total),
                    style: context.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Delete audio
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: colors.error.withValues(alpha: 0.7),
            size: 20,
          ),
          onPressed: () {
            final newContent = Map<String, dynamic>.from(widget.block.content)
              ..remove('audioPath');
            sl<BlockViewModel>().updateBlock(
              widget.block.copyWith(content: newContent),
            );
          },
        ),
      ],
    );
  }

  void _startRecording() {
    _isRecording.value = true;
    _recordingDuration.value = Duration.zero;

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordingDuration.value += const Duration(seconds: 1);
    });

    // TODO: Integrate actual audio recording via record package
  }

  void _stopRecording() {
    _isRecording.value = false;
    _recordingTimer?.cancel();

    // TODO: Save recording and update block content
    sl<BlockViewModel>().updateBlock(
      widget.block.copyWith(
        content: {
          ...widget.block.content,
          'audioPath':
              'recorded_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
          'duration': _recordingDuration.peek().inSeconds,
        },
      ),
    );
  }

  void _startPlayback() {
    _isPlaying.value = true;
    // TODO: Integrate actual audio playback
  }

  void _pausePlayback() {
    _isPlaying.value = false;
    // TODO: Pause actual audio playback
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
