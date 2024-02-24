class EngineException implements Exception {
  const EngineException(this.error);

  final dynamic error;

  @override
  String toString() => '(ffmpeg error) $error';
}

class FailedToGetFrameFromMedia implements Exception {
  const FailedToGetFrameFromMedia(this.reason);

  final dynamic reason;

  @override
  String toString() => '(failed to extract frame) $reason';
}
