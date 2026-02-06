class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Exception']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Exception']);
}

class VoiceException implements Exception {
  final String message;
  VoiceException([this.message = 'Voice Exception']);
}
