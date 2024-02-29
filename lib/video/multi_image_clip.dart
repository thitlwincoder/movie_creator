import 'package:flutter/widgets.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart' show Transition;

class MutliImageClip {
  MutliImageClip({
    required Size size,
    required Alignment alignment,
    required Transition transition,
    required Duration duration,
    required List<String> paths,
  });
}
