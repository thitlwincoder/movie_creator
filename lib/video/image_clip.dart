import 'dart:io';

import 'package:moviepy_flutter/moviepy_flutter.dart' show VideoClip;

class ImageClip extends VideoClip {
  ImageClip();

  @override
  Future<void> writeVideoFile(File output) async {}
}
