import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart' show Clip, Transition;

class MutliImageClip extends Clip {
  MutliImageClip({
    required this.size,
    required this.alignment,
    required Transition transition,
    required Duration duration,
    required this.paths,
  }) {
    super.duration = duration;
  }

  final List<String> paths;
  final Size size;
  final Alignment alignment;

  @override
  Future<void> writeVideoFile(File output) {
    // TODO: implement writeVideoFile
    throw UnimplementedError();
  }
}
