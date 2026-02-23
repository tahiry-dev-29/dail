import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

/// Service to handle audio recording and playback
class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  // Streams for UI updates
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;
  Stream<void> get onPlayerComplete => _player.onPlayerComplete;
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  String? _currentRecordingPath;

  /// Start recording audio
  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${dir.path}/audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      _currentRecordingPath = '${audioDir.path}/${const Uuid().v4()}.m4a';

      const config = RecordConfig(); // Default is m4a/aac
      await _recorder.start(config, path: _currentRecordingPath!);
    }
  }

  /// Stop recording and return the file path
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path;
  }

  /// Play audio from local path
  Future<void> play(String path) async {
    await _player.stop();
    await _player.play(DeviceFileSource(path));
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.resume();
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
  }

  /// Seek to position
  Future<void> seek(Duration duration) async {
    await _player.seek(duration);
  }

  /// Dispose resources
  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}
