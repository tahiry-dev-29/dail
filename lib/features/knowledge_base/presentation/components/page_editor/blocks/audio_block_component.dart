import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/atoms/app_typography.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/domain/services/voice_service.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioBlockComponent extends HookWidget {
  final BlockEntity block;

  const AudioBlockComponent({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final voiceService = useMemoized(() => sl<IVoiceService>());
    final blockVM = sl<BlockViewModel>();

    // State
    final isRecording = useState(false);
    final isPlaying = useState(false);
    final duration = useState(Duration.zero);
    final position = useState(Duration.zero);
    final amplitude = useState(0.0);
    final audioPath = useState<String?>(block.content['path'] as String?);

    // Recording logic
    Future<void> startRecording() async {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/voice_note_${const Uuid().v4()}.m4a';

      await voiceService.startRecording(path);
      isRecording.value = true;
      audioPath.value = path;
    }

    Future<void> stopRecording() async {
      await voiceService.stopRecording();
      isRecording.value = false;

      // Update block with new path
      if (audioPath.value != null) {
        blockVM.updateBlock(
          block.copyWith(content: {...block.content, 'path': audioPath.value}),
        );
      }
    }

    // Playback logic
    Future<void> togglePlayback() async {
      if (audioPath.value == null) return;

      if (isPlaying.value) {
        await voiceService.pause();
        isPlaying.value = false;
      } else {
        await voiceService.play(audioPath.value!);
        isPlaying.value = true;
      }
    }

    // Listeners
    useEffect(() {
      final ampSub = voiceService.amplitudeStream.listen((amp) {
        if (isRecording.value) amplitude.value = amp;
      });

      final posSub = voiceService.positionStream.listen((pos) {
        position.value = pos;
      });

      final durSub = voiceService.durationStream.listen((dur) {
        duration.value = dur;
      });

      // When audio finishes
      final finishSub = voiceService.positionStream.listen((pos) {
        if (pos >= duration.value && duration.value > Duration.zero) {
          isPlaying.value = false;
        }
      });

      return () {
        ampSub.cancel();
        posSub.cancel();
        durSub.cancel();
        finishSub.cancel();
      };
    }, []);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          // Control Button
          GestureDetector(
            onTap: () {
              if (audioPath.value == null && !isRecording.value) {
                startRecording();
              } else if (isRecording.value) {
                stopRecording();
              } else {
                togglePlayback();
              }
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: isRecording.value ? colors.error : colors.accent,
              child: Icon(
                isRecording.value
                    ? Icons.stop
                    : (audioPath.value == null
                          ? Icons.mic
                          : (isPlaying.value ? Icons.pause : Icons.play_arrow)),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Visualization / Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRecording.value)
                  Text(
                    'Recording... ${amplitude.value.toStringAsFixed(1)} dB',
                    style: context.bodySmall.copyWith(color: colors.error),
                  )
                else if (audioPath.value != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: duration.value.inMilliseconds > 0
                            ? position.value.inMilliseconds /
                                  duration.value.inMilliseconds
                            : 0.0,
                        backgroundColor: colors.border,
                        valueColor: AlwaysStoppedAnimation(colors.accent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDuration(position.value)} / ${_formatDuration(duration.value)}',
                        style: context.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Tap to record voice note',
                    style: context.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
