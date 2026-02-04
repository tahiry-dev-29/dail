abstract class IVoiceService {
  Future<void> startRecording(String path);
  Future<String?> stopRecording();
  Future<void> play(String path);
  Future<void> pause();
  Future<void> stop();
  Stream<double> get amplitudeStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Future<void> dispose();
}
