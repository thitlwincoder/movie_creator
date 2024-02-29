import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart'
    show Clip, Transition, VideoClip;
import 'package:moviepy_flutter/video/utils/effect.dart';

class ImageClip extends Clip {
  ImageClip({
    required this.path,
    required Alignment alignment,
    double? scale,
    Effect? effect,
  });

  final String path;

  @override
  Future<void> writeVideoFile(File output) async {}
}
