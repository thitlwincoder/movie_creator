class EngineException implements Exception {
  const EngineException(this.error);

  final dynamic error;

  @override
  String toString() => '(ffmpeg error) $error';
}
