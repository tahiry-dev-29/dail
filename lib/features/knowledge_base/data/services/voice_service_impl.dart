import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_os/features/knowledge_base/domain/services/voice_service.dart';
import 'package:record/record.dart';

class VoiceServiceImpl implements IVoiceService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> startRecording(String path) async {
    if (await _recorder.hasPermission()) {
      await _recorder.start(const RecordConfig(), path: path);
    }
  }

  @override
  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  @override
  Future<void> play(String path) async {
    await _player.play(DeviceFileSource(path));
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Stream<double> get amplitudeStream {
    return _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .map((amp) => amp.current);
  }

  @override
  Stream<Duration> get positionStream => _player.onPositionChanged;

  @override
  Stream<Duration> get durationStream => _player.onDurationChanged;

  @override
  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}
