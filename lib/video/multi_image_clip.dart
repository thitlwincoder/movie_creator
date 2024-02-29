import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart' show Clip, Transition;

class MutliImageClip extends Clip {
  MutliImageClip({
    required Size size,
    required Alignment alignment,
    required Transition transition,
    required Duration duration,
    required List<String> paths,
  });

  @override
  Future<void> writeVideoFile(File output) {
    // TODO: implement writeVideoFile
    throw UnimplementedError();
  }
}
