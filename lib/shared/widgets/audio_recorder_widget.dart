import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/shared/services/audio_service.dart';
import 'package:daily_os/shared/utils/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Shared AudioRecorderWidget — Premium Glass UI for recording/playing audio
class AudioRecorderWidget extends StatefulWidget {
  final String? audioPath;
  final int? audioDurationMs;
  final Function(String? path, int? durationMs)? onSaved;
  final VoidCallback? onDelete;

  const AudioRecorderWidget({
    super.key,
    this.audioPath,
    this.audioDurationMs,
    this.onSaved,
    this.onDelete,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final _isRecording = signal(false);
  final _isPlaying = signal(false);
  final _recordingDuration = signal(Duration.zero);
  final _playbackPosition = signal(Duration.zero);
  final _totalDuration = signal(Duration.zero);

  Timer? _recordingTimer;
  StreamSubscription? _posSub;
  StreamSubscription? _stateSub;

  @override
  void initState() {
    super.initState();
    final audioService = sl<AudioService>();

    _posSub = audioService.onPositionChanged.listen((pos) {
      _playbackPosition.value = pos;
    });

    _stateSub = audioService.onPlayerStateChanged.listen((state) {
      _isPlaying.value = state == PlayerState.playing;
    });

    if (widget.audioDurationMs != null) {
      _totalDuration.value = Duration(milliseconds: widget.audioDurationMs!);
    }
  }

  @override
  void didUpdateWidget(covariant AudioRecorderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioDurationMs != oldWidget.audioDurationMs &&
        widget.audioDurationMs != null) {
      _totalDuration.value = Duration(milliseconds: widget.audioDurationMs!);
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _posSub?.cancel();
    _stateSub?.cancel();
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

    final hasAudio = widget.audioPath != null && widget.audioPath!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRecording
              ? colors.error.withValues(alpha: 0.5)
              : colors.border.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(12),
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
        GestureDetector(
          onTap: isRecording ? _stopRecording : _startRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isRecording
                  ? colors.error
                  : colors.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
              color: isRecording ? Colors.white : colors.error,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                isRecording
                    ? 'Enregistrement...'
                    : 'Enregistrer une note vocale',
                style: context.bodyMedium.copyWith(
                  fontWeight: isRecording ? .bold : .normal,
                  color: isRecording ? colors.error : colors.textPrimary,
                ),
              ),
              if (isRecording)
                Text(
                  _formatDuration(elapsed),
                  style: context.bodySmall.copyWith(
                    color: colors.error.withValues(alpha: 0.8),
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
        GestureDetector(
          onTap: isPlaying ? _pausePlayback : _startPlayback,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: colors.accent,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              LinearProgressIndicator(
                value: total.inMilliseconds > 0
                    ? position.inMilliseconds / total.inMilliseconds
                    : 0.0,
                backgroundColor: colors.border.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(colors.accent),
                borderRadius: BorderRadius.circular(10),
                minHeight: 4,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: context.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    _formatDuration(total),
                    style: context.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.onDelete != null)
          IconButton(
            icon: Icon(Icons.close_rounded, color: colors.textMuted, size: 20),
            onPressed: widget.onDelete,
          ),
      ],
    );
  }

  void _startRecording() async {
    final audioService = sl<AudioService>();
    try {
      await audioService.startRecording();
      _isRecording.value = true;
      _recordingDuration.value = Duration.zero;
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _recordingDuration.value += const Duration(seconds: 1);
      });
    } catch (e) {
      if (mounted) {
        ToastService.show(context, message: 'Erreur permission micro');
      }
    }
  }

  void _stopRecording() async {
    final audioService = sl<AudioService>();
    final path = await audioService.stopRecording();
    _isRecording.value = false;
    _recordingTimer?.cancel();

    if (path != null && widget.onSaved != null) {
      widget.onSaved!(path, _recordingDuration.peek().inMilliseconds);
    }
  }

  void _startPlayback() async {
    if (widget.audioPath != null) {
      await sl<AudioService>().play(widget.audioPath!);
    }
  }

  void _pausePlayback() async {
    await sl<AudioService>().pause();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
