import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart'
    show Clip, Transition, VideoClip;
import 'package:movie_flutter/video/utils/effect.dart';

class ImageClip extends Clip {
  ImageClip({
    required this.path,
    required this.alignment,
    this.padding,
    double? scale,
    Effect? effect,
  });

  final String path;
  final EdgeInsets? padding;
  final Alignment alignment;

  @override
  Future<void> writeVideoFile(File output) async {}
}
