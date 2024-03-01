import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart' show Clip, Transition;

class MultiImageClip extends Clip {
  MultiImageClip({
    required Size size,
    required this.alignment,
    required Duration duration,
    required this.paths,
  }) {
    super.duration = duration;
    super.size = size;
  }

  final List<String> paths;
  final Alignment alignment;

  @override
  Future<void> writeVideoFile(File output) {
    // TODO: implement writeVideoFile
    throw UnimplementedError();
  }
}
